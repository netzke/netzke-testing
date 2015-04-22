Ext.Ajax.on 'beforerequest', ->
  Netzke.ajaxCount = window.ajaxCount || 0
  Netzke.ajaxCount += 1

Ext.Ajax.on 'requestcomplete', ->
  Netzke.ajaxCount -= 1

Ext.apply window,
  # Waits for all AJAX activity to stop, then calls the optional callback. If no callback was specified, returns a
  # promise. The first argument can be a number of milliseconds to wait before starting to listen to the AJAX activity
  # (handy when some Ext method implement a fixed delay before doing something, like triggering a column filter after it
  # was set).
  #
  # Examples:
  #
  #   wait ->
  #     afterAllAjaxActivityIsStopped()
  #
  #   wait 200, ->
  #     waitsAtLeast200MsBeforeCallingThis()
  #
  #   wait().then -> doSomething()
  wait: () ->
    waitInCycle = (callback) ->
      i = 0
      id = setInterval ->
        i += 1
        if i >= 100
          clearInterval(id)
          callback.call()

        # this way we ensure another 20ms cycle before we issue a callback
        i = 100 if Netzke.ajaxCount == 0
      , 200

    # wait ->
    #   callbackAsParameter()
    if typeof arguments[0] == 'function'
      return waitInCycle arguments[0]

    if Ext.isNumber(arguments[0])

      # wait 50, ->
      #   waitAtLeast50Seconds()
      if Ext.isFunction(arguments[1])
        delay = arguments[0]
        callback = arguments[1]
        setInterval ->
          waitInCycle(resolve)
        , delay
        return null

      # wait(50).then ->
      #   waitAtLeast50ThenResolve()
      else
        console.log("1", 1)
        delay = arguments[0]
        return new Promise (resolve, reject) ->
          setInterval ->
            waitInCycle(resolve)
          , delay

    return new Promise (resolve, reject) -> waitInCycle resolve

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
