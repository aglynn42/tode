menu actions
cutObjectMenuAction: listElement selectionIndex: selectionIndex
  | itemAttribute def |
  itemAttribute := listElement itemCache at: selectionIndex.
  def := itemAttribute object.
  self objectClipboard: def.
  def removeFromSystem: listElement topez.
  ^ listElement objectSerializer
    toString:
      {#'refreshList'.
      nil.
      #'addToClipboard:'.
      (def label)}