instance/class button bar support
browseClassProtocol: buttonBarClientElement
  ((TDBehaviorDefinition className: self className isMeta: true)
    appEnv: self appEnv;
    yourself)
    editUsing:
      ((TDEditorSpec
        topez: buttonBarClientElement topez
        editorAspect: #'classicProtocolList')
        windowName: #'classicProtocolList';
        windowLocation: #'classicProtocol';
        selectionIndex: 1;
        yourself).
  ^ true