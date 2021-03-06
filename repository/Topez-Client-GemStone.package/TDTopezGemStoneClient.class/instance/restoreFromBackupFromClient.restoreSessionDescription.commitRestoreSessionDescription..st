builtins
restoreFromBackupFromClient: backupPath restoreSessionDescription: restoreSessionDescription commitRestoreSessionDescription: commitRestoreSessionDescription
	| restoreSession originalSessionDescription |
	originalSessionDescription := self sessionDescription.
	[ 
	[ 
	"restore from backup"
	Transcript
		cr;
		show: '---Starting restore from ' , backupPath printString , ' (';
		print: TimeStamp now;
		show: ')'.
	self sessionDescription: restoreSessionDescription.
	restoreSession := self loginUsing: TodeInstallSession.
	self restoreStopOtherSessions: restoreSession.
	^ restoreSession
		executeStringExpectingStringNB: 'SystemRepository restoreFromBackup: ' , backupPath printString
		envId: self environmentId ]
		on: GsErrorNotification
		do: [ :ex | 
			ex errorNumber ~~ 4046
				ifTrue: [ ^ ex pass ].
			Transcript
				cr;
				show: ex description ].
	restoreSession logout.
	self sessionDescription: commitRestoreSessionDescription.
	restoreSession := self loginUsing: TodeInstallSession.
	[ 
	"commit restore"
	restoreSession
		executeStringExpectingStringNB:
			'| status |
	status := SystemRepository restoreStatus.
	(status asLowercase beginsWith: ''Restoring from Transaction Log files'' asLowercase)
		ifFalse: [ ^nil error: ''System is not prepared to commit restore: '', status].
	status := SystemRepository commitRestore.
	"normally terminates the session"
	^nil error: ''Commit restore failed: '', status'
		envId: self environmentId ]
		on: GsErrorNotification
		do: [ :ex | 
			ex errorNumber ~~ 4048
				ifTrue: [ ^ ex pass ].
			Transcript
				cr;
				show: ex description ].
	restoreSession logout ]
		ensure: [ self sessionDescription: originalSessionDescription ]