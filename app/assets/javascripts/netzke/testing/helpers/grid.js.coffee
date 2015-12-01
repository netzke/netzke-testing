Ext.apply window,
  grid: (value, lookup) ->
    # default to query by title for backwards compatibility
    lookup = lookup || 'title'
    if value && lookup == 'title'
      Ext.ComponentQuery.query('grid[title="'+value+'"]')[0] ||
      Ext.ComponentQuery.query('treepanel[title="'+value+'"]')[0]
    else if value && lookup == 'name'
      Ext.ComponentQuery.query('grid[name="'+value+'"]')[0] ||
      Ext.ComponentQuery.query('treepanel[name="'+value+'"]')[0]
    else
      Ext.ComponentQuery.query('grid{isVisible(true)}')[0] ||
      Ext.ComponentQuery.query('treepanel{isVisible(true)}')[0]

  expandRowCombo: (field, params) ->
    g = g || @grid()
    editor = g.getPlugin('celleditor')
    column = g.headerCt.items.findIndex('name', field) - 1
    editor.startEditByPosition({row: g.getSelectionModel().getCurrentPosition().rowIdx, column: column})
    editor.activeEditor.field.onTriggerClick()

  # Example:
  # addRecords {title: 'Foo'}, {title: 'Bar'}, to: grid('Books'), submit: true
  addRecords: ->
    params = arguments[arguments.length - 1]
    for record in arguments
      if (record != params)
        record = params.to.getStore().add(record)[0]
        record.isNew = true
    click button 'Apply' if params.submit

  addRecord: (recordData, params) ->
    params = params || []
    grid = params.to || @grid()
    record = grid.getStore().add(recordData)
    grid.getSelectionModel().select(grid.getStore().last())

  updateRecord: (recordData, params) ->
    params = params || []
    grid = params.to || @grid()
    record = grid.getSelectionModel().getSelection()[0]
    for key,value of recordData
      record.set(key, value)

  selectAssociation: (attr, value, callback) ->
    action = (cb) ->
      expandRowCombo attr
      wait ->
        select value, in: combobox(attr)
        cb()

    if callback
      action(callback)
    else
      new Promise (resolve, reject) ->
        action(resolve)

  valuesInColumn: (name, params = {}) ->
    grid = params.in || @grid()
    valueInCell(name, i, params) for i in [0..grid.getStore().getCount()-1]

  # Example:
  # valueInCell 'author__name', 2
  valueInCell: (column, rowIndex, params = {}) ->
    grid = params.in || @grid()
    r = grid.getStore().getAt(rowIndex)
    column = grid.headerCt.items.findBy (c) -> c.name is column

    el = Ext.DomQuery.select("table[data-recordid=#{r.internalId}] tbody tr td.x-grid-cell-#{column.id} div")[0]

    el.innerHTML

  selectAllRows: (params) ->
    params ?= {}
    grid = params.in || @grid()
    grid.getSelectionModel().selectRange(0, grid.getStore().getCount() - 1)

  # rowDisplayValues in: grid('Books'), of: grid('Books').getStore().last()
  # Without parameters, assumes the first found grid and the selected row
  rowDisplayValues: (params) ->
    params ?= {}
    grid = params.in || @grid()
    record = params.of || grid.getSelectionModel().getSelection()[0]

    visibleColumns = []
    Ext.each grid.columns, (c) ->
      visibleColumns.push(c) if c.isVisible()

    i = -1
    return Ext.Array.map(Ext.DomQuery.select('table[data-recordid="'+record.internalId+'"] tbody tr td div'), (cell) ->
      i++
      if visibleColumns[i].attrType == 'boolean'
        record.get(visibleColumns[i].name)
      else
        cell.innerHTML
    )

  # Examples:
  # selectLastRow()
  # selectLastRow in: grid('Book')
  selectLastRow: (params) ->
    params ?= {}
    grid = params.in || @grid()
    grid.getSelectionModel().select(grid.getStore().getCount() - 1)

  # Examples:
  # selectFirstRow()
  # selectFirstRow in: grid('Book')
  selectFirstRow: (params) ->
    params ?= {}
    grid = params.in || @grid()
    grid.getSelectionModel().select(0)

  # Examples:
  # selectRow 5
  # selectRow 5, in: grid('Book')
  selectRow: (n, params) ->
    params ?= {}
    grid = params.in || @grid()
    grid.getSelectionModel().select(n)

  # Example:
  # editLastRow {title: 'Foo', exemplars: 10}
  editLastRow: ->
    data = arguments[0]
    grid = Ext.ComponentQuery.query("grid")[0]
    store = grid.getStore()
    record = store.last()
    for key of data
      record.set(key, data[key])

  completeEditing: (g) ->
    g = g || @grid()
    e = g.getPlugin('celleditor')
    e.completeEdit()
