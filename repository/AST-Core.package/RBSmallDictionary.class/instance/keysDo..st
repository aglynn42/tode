enumerating
keysDo: aBlock
	1 to: tally do: [ :each | aBlock value: (keys at: each) ]