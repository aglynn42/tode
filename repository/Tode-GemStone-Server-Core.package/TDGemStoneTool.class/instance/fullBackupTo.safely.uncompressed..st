bu
fullBackupTo: backupPath safely: safely uncompressed: uncompressed
  | backupFilename backupDirName backupDir result |
  ServerFileDirectory
    splitName: backupPath
    to: [ :dirPath :filename | 
      backupDirName := dirPath.
      backupFilename := filename ].
  backupDir := ServerFileDirectory on: backupDirName.
  (backupDir fileExists: backupFilename)
    ifTrue: [ 
      safely
        ifTrue: [ 
          Transcript
            cr;
            show:
                'Skipping backup, --safely specified and ' , backupFilename printString
                    , ' exists.'.
          ^ false ].
      backupDir deleteFileNamed: backupFilename ].
  System commitTransaction.
  result := uncompressed
    ifTrue: [ SystemRepository fullBackupTo: backupPath ]
    ifFalse: [ SystemRepository fullBackupCompressedTo: backupPath ].
  result == true
    ifFalse: [ ^ self error: 'Could not complete the backup: ' , result ].	"we have been left outside of transaction in manual
	 transaction mode"
  System transactionMode: #'autoBegin'.
  ^ true