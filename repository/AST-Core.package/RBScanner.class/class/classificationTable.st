accessing
classificationTable
	classificationTable isNil 
		ifTrue: [ self initializeClassificationTable ].
	^ classificationTable