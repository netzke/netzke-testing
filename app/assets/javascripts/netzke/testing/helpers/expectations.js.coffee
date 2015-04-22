Ext.apply window,
  expectToSee: (cmp) ->
    throw cmp + " not found" if Ext.isString(cmp)
    expect(Ext.isObject(cmp) || Ext.isElement(cmp)).to.be.ok()

  expectToNotSee: (el) ->
    expect(Ext.isString(el)).to.be.ok()

  expectDisabled: (cmp) ->
    throw cmp + " not found" if Ext.isString(cmp)
    expect(cmp.isDisabled()).to.be(true)

  expectEnabled: (cmp) ->
    throw cmp + " not found" if Ext.isString(cmp)
    expect(cmp.isDisabled()).to.be(false)

  expectInvisibleBodyOf: (cmp) ->
    throw cmp + " not found" if Ext.isString(cmp)
    expect(cmp.body.isVisible()).to.be false
