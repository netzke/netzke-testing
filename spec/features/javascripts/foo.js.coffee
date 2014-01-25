describe 'Foo', ->
  afterEach (done) ->
    done()

  it 'shows as a panel with title "Test component"', ->
    expectToSee header "Test component"
