accessing
messageText
	"Return an exception's message text."

	^ messageText ifNil: [ self description ]