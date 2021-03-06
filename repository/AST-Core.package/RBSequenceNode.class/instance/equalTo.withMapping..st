comparing
equalTo: anObject withMapping: aDictionary 
	self class = anObject class ifFalse: [^false].
	self statements size = anObject statements size ifFalse: [^false].
	1 to: self statements size
		do: 
			[:i | 
			((self statements at: i) equalTo: (anObject statements at: i)
				withMapping: aDictionary) ifFalse: [^false]].
	aDictionary values asSet size = aDictionary size ifFalse: [^false].	"Not a one-to-one mapping"
	self temporaries
		do: [:each | aDictionary removeKey: each name ifAbsent: []].
	^true