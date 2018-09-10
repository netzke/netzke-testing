describe 'Foo', ->
  afterEach (done) ->
    done()

  it 'shows as a panel with title "Test component"', ->
    expectToSee header "Test component"

  it 'can wait with a timeout and a callback function', ->
    wait 1, ->
