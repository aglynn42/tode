actions
defaultAction
	| answer |
	self clientObj
		exception: self exceptionOopType
		context: self contextOopType.
	self clientObj interactive
		ifFalse: [ ^self defaultRuntimeError ].
	answer := (TDInteractiveChooseExceptionHandling
		message: (self description withNoLineLongerThan: 80)) signal.
	answer
		ifNil: [ ^ {#debug.
			self} ].	"Debug -- cancel"
	answer
		ifTrue: [ ^ #resume ].	"Proceed -- true"
	^ {#abort.
	(self clientObj objectSerializer toString: 'Aborted...')}	"Abort -- false (default)s"