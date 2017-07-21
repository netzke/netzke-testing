# Query helpers will return a string denoting what was searched for, when a component/element itself could not be found. This can be used by other helpers to display a more informative error.
# KNOWN ISSUE: if the passed parameter contains symbols like "():,.", it results in an invalid query.
Ext.apply window,
  header: (title) ->
    Ext.ComponentQuery.query('panel{isVisible(true)}[title="'+title+'"]')[0] || 'header ' + title

  tab: (title) ->
    Ext.ComponentQuery.query('tab[text="'+title+'"]')[0] || 'tab ' + title

  panelWithContent: (text) ->
    Ext.DomQuery.select("div.x-panel-body:contains(" + text + ")")[0] || 'panel with content ' + text

  button: (text, params = {}) ->
    context = params.within || Ext.ComponentQuery

    button = context.query("button{isVisible(true)}[text='"+text+"']")[0]
    button ||= context.query("button{isVisible(true)}[tooltip='"+text+"']")[0]
    button || "button " + text

  panel: (name) ->
    Ext.getCmp(name)

  tool: (type) ->
    Ext.ComponentQuery.query("tool{isVisible(true)}[type='"+type+"']")[0] || 'tool ' + type

  component: (id) ->
    Ext.ComponentQuery.query("panel{isVisible(true)}[id='"+id+"']")[0] || 'component ' + id

  somewhere: (text) ->
    Ext.DomQuery.select("*:contains(" + text + ")")[0] || 'anywhere ' + text

  # used as work-around for the invalid query problem
  currentPanelTitle: ->
    panel = Ext.ComponentQuery.query('panel[hidden=false]')[0]
    throw "Panel not found" if !panel
    panel.getHeader().getTitle().text

  combobox: (name) ->
    Ext.ComponentQuery.query("combo{isVisible(true)}[name='"+name+"']")[0] ||
      "combobox '#{name}'"

  icon: (tooltip) ->
    Ext.DomQuery.select('img[data-qtip="'+tooltip+'"]')[0] || 'icon ' + tooltip

  textfield: (name) ->
    Ext.ComponentQuery.query("textfield{isVisible(true)}[name='"+name+"']")[0] ||
      activateField(name) ||
      Ext.ComponentQuery.query("textfield{isVisible(false)}[name='"+name+"']")[0] ||
      "textfield '#{name}'"

  numberfield: (name) ->
    Ext.ComponentQuery.query("numberfield{isVisible(true)}[name='"+name+"']")[0] ||
      "numberfield '#{name}'"

  datefield: (name) ->
    Ext.ComponentQuery.query("datefield{isVisible(true)}[name='"+name+"']")[0] ||
      "datefield '#{name}'"

  xdatetime: (name) ->
    Ext.ComponentQuery.query("xdatetime{isVisible(true)}[name='"+name+"']")[0] ||
      "xdatetime '#{name}'"

  activateField: (name) ->
    # This is needed because Ext 6 addon for inline editing creates an input in dom
    # only when it was activated (double clicked)

    column = Ext.ComponentQuery.query("gridcolumn[name='"+name+"']")[0]
    gridView = Ext.ComponentQuery.query("gridview")[0]
    return unless column && gridView

    cell = gridView.getCell(0, column)
    return unless cell

    clickEvent = document.createEvent('MouseEvents')
    clickEvent.initEvent('dblclick', true, true);
    cell.el.dom.dispatchEvent(clickEvent);
    Ext.ComponentQuery.query("textfield{isVisible(true)}[name='"+name+"']")[0]

  textFieldWith: (text) ->
    _componentLike "textfield", "value", text

  comboboxWith: (text) ->
    _componentLike "combo", "rawValue", text

  textAreaWith: (text) ->
    _componentLike "textareafield", "value", text

  numberFieldWith: (value) ->
    _componentLike "numberfield", "value", value

  activeWindow: ->
    Ext.WindowMgr.getActive()

  dateTimeFieldWith: (value) ->
    res = "xdatetime with value '#{value}'"
    Ext.each Ext.ComponentQuery.query('xdatetime'), (item) ->
      if item.getValue().toString() == (new Date(value)).toString()
        res = item
        return
    res

  dateFieldWith: (value) ->
    res = "datefield with value '#{value}'"
    Ext.each Ext.ComponentQuery.query('datefield'), (item) ->
      if item.getValue().toString() == (new Date(value)).toString()
        res = item
        return
    res

  eastRegion: ->
    Ext.ComponentQuery.query("[region=east]")[0]

  westRegion: ->
    Ext.ComponentQuery.query("[region=west]")[0]

  southRegion: ->
    Ext.ComponentQuery.query("[region=south]")[0]

  northRegion: ->
    Ext.ComponentQuery.query("[region=north]")[0]

  _componentLike:(type,attr,value)->
    Ext.ComponentQuery.query(type+'['+attr+'='+value+']')[0] || type + " with " + attr + " '" + value + "'"

# alias
window.anywhere = window.somewhere
