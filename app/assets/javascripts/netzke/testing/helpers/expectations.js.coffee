Ext.apply window, (->
  throwIfNotFound = (cmp) ->
    throw new Error(cmp + " not found") if Ext.isString(cmp)

  expectToSee: (cmp) ->
    throwIfNotFound(cmp)
    expect(Ext.isObject(cmp) || Ext.isElement(cmp)).to.be.ok()

  expectToNotSee: (el) ->
    expect(Ext.isString(el)).to.be.ok()

  expectDisabled: (cmp) ->
    throwIfNotFound(cmp)
    expect(cmp.isDisabled()).to.be(true)

  expectEnabled: (cmp) ->
    throwIfNotFound(cmp)
    expect(cmp.isDisabled()).to.be(false)

  expectInvisibleBodyOf: (cmp) ->
    throwIfNotFound(cmp)
    expect(cmp.body.isVisible()).to.be false
  )()
