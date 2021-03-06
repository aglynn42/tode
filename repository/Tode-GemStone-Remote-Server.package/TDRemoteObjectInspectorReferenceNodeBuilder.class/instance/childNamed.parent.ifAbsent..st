as yet unclassified
childNamed: elementName parent: parentNode ifAbsent: absentBlock
  | obj objOop |
  elementName = '<<more>>'
    ifTrue: [ obj := 'You can only see the first 100 elements... for now' ]
    ifFalse: [ 
      elementName = '(oop)'
        ifTrue: [ obj := parentNode basicContents childNodeNamedOops at: elementName ]
        ifFalse: [ 
          elementName isAllDigits
            ifTrue: [ 
              [ 
              objOop := parentNode basicContents childNodeIndexableOops
                at: elementName asNumber ]
                on: Error
                do: [ :ex | 'error accessing index: ' , elementName printString , ' --> ' , ex description ] ]
            ifFalse: [ objOop := parentNode basicContents childNodeNamedOops at: elementName ].
          obj := TDRemoteObjectInspectorReference
            objectOop: objOop
            session: parentNode basicContents session ] ].
  ^ (obj
    asTDObjectNode: parentNode
    topez: parentNode topez
    aspect: parentNode builderAspect)
    name: elementName;
    yourself