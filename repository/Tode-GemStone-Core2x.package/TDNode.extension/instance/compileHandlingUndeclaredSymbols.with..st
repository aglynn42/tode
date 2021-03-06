*tode-gemstone-core2x-as yet unclassified
compileHandlingUndeclaredSymbols: compileBlock with: aSymbolList
  [ 
  [ ^ compileBlock value: aSymbolList ]
    on: self compilerExceptionSet
    do: [ :ex | 
      | undefSymbol symbols undefinedSymbols undefinedSymbolList |
      undefSymbol := true.
      symbols := {}.
      ex errorDetails
        do: [ :errArray | 
          (errArray atOrNil: 1) == 1031
            ifTrue: [ symbols add: (errArray atOrNil: 5) asSymbol ]
            ifFalse: [ undefSymbol := false ] ].
      undefSymbol
        ifTrue: [ 
          (UndefinedSymbolNotification new
            gsArguments: ex gsArguments;
            signal)
            ifTrue: [ 
              "attempt auto-define of undefined symbols"
              (undefinedSymbols := aSymbolList objectNamed: #'UndefinedSymbols')
                ifNotNil: [ 
                  symbols
                    do: [ :sym | 
                      | s |
                      (s := undefinedSymbols at: sym otherwise: nil)
                        ifNil: [ 
                          s := Set new.
                          undefinedSymbols at: sym put: s ] ].
                  undefinedSymbolList := aSymbolList
                    objectNamed: #'UndefinedSymbolList'.
                  [ ^ compileBlock value: aSymbolList , undefinedSymbolList ]
                    on: self compilerExceptionSet
                    do: [ :exb | undefSymbol := false ] ] ]
            ifFalse: [ undefSymbol := false ] ].
      undefSymbol
        ifFalse: [ ex outer ] ] ]
    on: self compilerWarningSet
    do: [ :warning | warning resume ]