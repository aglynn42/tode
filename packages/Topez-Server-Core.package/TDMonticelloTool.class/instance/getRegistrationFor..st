as yet unclassified
getRegistrationFor: configName
  "baseline then config is a better lookup order"

  | registry |
  registry := MetacelloProjectRegistration registry.
  registry baselineRegistry
    at: 'BaselineOf' , configName
    ifPresent: [ :registration | ^ registration ].
  registry configurationRegistry
    at: 'ConfigurationOf' , configName
    ifPresent: [ :registration | ^ registration ].
  registry error: 'No configuration name: ' , configName printString