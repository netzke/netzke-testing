describe 'Foo', ->
  it 'should display proper header', ->
    expect(Ext.ComponentQuery.query('panel[id="foo"]')[0].getHeader().title).to.eql 'Test component'
