*tode-gemstone-core2x-commands
methodReferenceForGsNMethod: gsNMethod username: username
  | methodRef |
  methodRef := MethodReference new
    setStandardClass: gsNMethod inClass
    methodSymbol: gsNMethod selector.
  username
    ifNotNil: [ 
      | symDictAr symbolList |
      symDictAr := {(symbolList := (AllUsers
        userWithId: username
        ifAbsent: [ System myUserProfile ]) symbolList)
        dictionaryAndSymbolOf: gsNMethod inClass theNonMetaClass}.
      methodRef symbolDictionary: ((symDictAr at: 1) at: 1) ].
  ^ methodRef