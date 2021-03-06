menu actions
browseGitMethodVersions: clientElement methodDefinition: methodDef
  | configDef gitTool filePath commitish gitDirectory registration gitRepo packageDef packageName classExtension metaDirName methodFilename commitLog mcTool wc |
  configDef := methodDef configurationOf.
  configDef ifNil: [ ^ false ].
  registration := configDef projectRegistrationDef.
  registration ifNil: [ ^ false ].
  registration hasGitRepository
    ifFalse: [ ^ false ].
  packageDef := methodDef packageOf.
  packageName := packageDef packageName.
  mcTool := clientElement topez toolInstanceFor: 'mc'.
  gitTool := clientElement topez toolInstanceFor: 'git'.
  gitRepo := registration repository.
  wc := mcTool resolveWorkingCopyReference: packageName.
  classExtension := '.class'.
  (methodDef methodProtocol beginsWith: '*')
    ifTrue: [ classExtension := '.extension' ].
  metaDirName := 'instance'.
  methodDef isMeta
    ifTrue: [ metaDirName := 'class' ].
  methodFilename := MCFileTreeStCypressWriter
    fileNameForSelector: methodDef selector.
  filePath := 'repository/' , (wc metacelloPackageNameWithBranch at: 2)
    , '.package' , '/' , methodDef className asString , classExtension , '/'
    , metaDirName , '/' , methodFilename , '.st'.
  gitDirectory := registration gitRootDirectory.
  commitLog := gitTool
    gitlogFilePath: filePath
    limit: 100
    gitRepoDirectory: gitDirectory.
  commitish := registration versionString.
  (TDGitRawHistoryBrowser new
    topez: clientElement topez;
    source: commitish;
    destination: commitish;
    rawCommitLog: commitLog gitRepoDirectory: gitDirectory;
    logItemSelectedBlock: [ :listEl :rawHistoryBrowser :sha | 
          | diffs |
          diffs := (listEl topez toolInstanceFor: 'git')
            gitdifftool: sha , '^'
            destination: sha
            cached: false
            filePath: filePath
            gitRepoDirectory: gitDirectory
            diffClass: TDFileTreeDiff.
          diffs size > 1
            ifTrue: [ self error: 'Unexpected diffs size: ' , diffs size printString ].
          rawHistoryBrowser
            displayObject: (diffs at: 1)
            listElement: listEl
            label: 'Changes for [' , sha , '] ' , methodDef label ];
    windowLabel: 'History for ' , methodDef label;
    yourself) open.
  ^ true