Ext.apply window,
  fill: (field, params) ->
    field.setValue(params.with)

  expandCombo: (combo) ->
    combo = Ext.ComponentQuery.query("combo{isVisible(true)}[name="+combo+"]")[0]
    combo.onTriggerClick()
