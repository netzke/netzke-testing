Ext.Ajax.on 'beforerequest', ->
  Netzke.ajaxCount = window.ajaxCount || 0
  Netzke.ajaxCount += 1

Ext.Ajax.on 'requestcomplete', ->
  Netzke.ajaxCount -= 1

Ext.apply window,
  # Examples:
  #
  #   wait ->
  #     afterAllAjaxActivityIsStopped()
  #
  #   wait 2000, ->
  #     afterTwoSeconds()
  wait: () ->
    if typeof arguments[0] == 'function'
      callback = arguments[0]
      i = 0
      id = setInterval ->
        i += 1
        if i >= 100
          clearInterval(id)
          callback.call()

        # this way we ensure another 20ms cycle before we issue a callback
        i = 100 if Netzke.ajaxCount == 0
      , 100
    else
      delay = arguments[0]
      callback = arguments[1]
      setInterval ->
        callback.call()
      , delay

  click: (cmp) ->
    if Ext.isString(cmp)
      throw "Could not locate " + cmp
    else if (cmp.isXType) # is Ext component
      if (cmp.isXType('tool'))
        # a hack needed for tools
        el = cmp.toolEl
      else
        el = cmp.getEl()

      el.dom.click()
    else if Ext.isElement(cmp)
      cmp.click()

  # Closes the first found window
  closeWindow: ->
    Ext.ComponentQuery.query("window[hidden=false]")[0].close()

  select: (value, params, callback) ->
    params ?= params
    combo = params.in
    if combo.isExpanded
      combo.setValue combo.findRecordByDisplay value
      combo.collapse()
    else
      combo.onTriggerClick()
      if callback
        wait ->
          rec = combo.findRecordByDisplay value
          combo.select rec
          combo.fireEvent('select', combo, rec )
          combo.collapse()
          callback.call()
      else
        rec = combo.findRecordByDisplay value
        combo.select rec
        combo.fireEvent('select', combo, rec )
        combo.collapse()
