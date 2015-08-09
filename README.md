# Netzke Testing [![Gem Version](https://fury-badge.herokuapp.com/rb/netzke-testing.png)](http://badge.fury.io/rb/netzke-testing)

This gem helps with development and testing of Netzke components. In parcticular, it helps you with:

  * isolated component development
  * client-side testing of components with Mocha and Expect.js

Usage:

    gem 'netzke-testing'

## Isolated component development

The gem implements a Rails engine, which (in development and test environments only) adds a route to load your
application's Netzke components individually, which can be useful for isolated development.  Example (say, we have a
UserGrid component defined):

    http://localhost:3000/netzke/components/UserGrid

This will load a view with UserGrid occupying the available window width, with default height of 400px. You can change
the height by providing the `height` parameter in the URL:

    http://localhost:3000/netzke/components/UserGrid?height=600

## Testing components with Mocha and Expect.js

Place the Mocha specs (written in Coffeescript) for your components inside `spec/features/javascripts` folder. An
example spec may look like this (in `spec/features/javascripts/user_grid.js.coffee`):

    describe 'UserGrid', ->
      it 'shows proper title', ->
        grid = Ext.ComponentQuery.query('panel[id="user_grid"]')[0]
        expect(grid.getHeader().title).to.eql 'Test component'

This spec can be run by appending the `spec` parameter to the url:

    http://localhost:3000/netzke/components/UserGrid?spec=user_grid

Specs can be structured into directories. For example, let's say we have a namescope for admin components:

    class Admin::UserGrid < Netzke::Basepack::Grid
    end

It makes sense to put the corresponding specs in `spec/features/javascripts/admin/user_grid.js.coffee`. In this case,
   the URL to run the Mocha specs will be:

    http://localhost:3000/netzke/components/UserGrid?spec=admin/user_grid

## Mocha spec helpers

The gem provides a number of helpers that may help you writing less code and make your specs look something like this:

    describe 'UserGrid', ->
      it 'allows instant removing of all users with a single button click', (done) ->
        click button 'Remove all'
        wait ->
          expectToSee header 'Empty'
          done()

In order to enable these helpers, add the following line somewhere in your `RSpec.configure` block:

    RSpec.configure do |config|
      Netzke::Testing.rspec_init(config)
      # ...
    end

Keep in mind the following:

  * the current set of helpers is in flux, and may be drastically changed sooner than you may expect
  * the helpers directly pollute the global (`window`) namespace; if you decide you're better off without provided
  helpers, specify 'no-helpers=true' as an extra URL parameter

See the [source
code](https://github.com/netzke/netzke-testing/tree/master/app/assets/javascripts/netzke/testing/helpers) for currently
implemented helpers (TODO: document them). Also, refer to other Netzke gems source code (like netzke-core and
netzke-basepack) to see examples using the helpers.

## Adding custom spec helpers

You may add (or require, by means of Sprockets) additional helpers in `app/assets/javascripts/netzke/testing.js`, which will be included in the testing template *after* the helpers provided by netzke-testing. For example:

    // in app/assets/javascripts/netzke/testing.js
    //= require_tree ./testing

    # in app/assets/javascripts/netzke/testing/grid.js.coffee
    Ext.apply window,
      enableColumnFilter: (column, value) ->
      # ...

After this the `enableColumnFilter` helper will be available in your Mocha specs.

## Testing with selenium webdriver

Generate the `netzke_mocha_spec.rb` file that will automatically run the specs that follow a certain naming convention:

    rails g netzke_testing

This spec will pick up all the `*_spec.js.coffee` files from `spec/features/javascripts` folder and generate an `it`
clause for each of them. Let's say we want to create the spec for UserGrid. For this we name the spec file
`spec/features/javascripts/user_grid_spec.js.coffee`. And the other way around: when `netzke_mocha_spec.rb` finds a file
called `spec/features/javascripts/order_grid_spec.js.coffee`, it'll assume existance of `OrderGrid` component that
should be tested.

## Mixing client- and server-side testing code

Often we want to run some Ruby code before running the Mocha spec (e.g. to seed some test data using factories), or
after (e.g. to assert changes in the database). In this case you can create a RSpec spec that uses the `run_mocha_spec`
helper provided by the `netzke_testing` gem. Here's an example (in `spec/user_grid_spec.rb`):

    require 'spec_helper'
    feature GridWithDestructiveButton do
      it 'allows instant removing of all records with a single button click', js: true do
        10.times { FactoryGirl.create :user }
        User.count.should == 10
        run_mocha_spec 'grid_with_destructive_button'
        User.count.should == 0
      end
    end

The `run_mocha_spec` here will run a Mocha spec from `spec/grid_with_destructive_button.js.coffee`.

You can explicitely specify a component to run the spec on:

    run_mocha_spec 'grid_with_destructive_button', component: 'UserGrid'

To investigate the problem in case of a failing Mocha spec, set `stop_on_error` to `true` (this will keep the browser open on the failed spec):

    run_mocha_spec 'grid_with_destructive_button', stop_on_error: true

(in this case you'll have to terminate the specs by pressing `ctrl+c`)

## Setting timeout for longer running JS specs

Netzke-testing by default assumes that your specs do not take longer than 5 seconds, and mark them failed if they do. If your spec are as complex as taking longer than that, you can increase this value in an initializer, e.g.:

    # in config/initializers/netzke.rb
    Netzke::Testing.setup do |config|
      config.js_timeout = 10 # seconds
    end

You could also set this in `spec_helper.rb` like this:

    Netzke::Testing.js_timeout = 10

However, keep in mind, that this won't have effect on running specs manually in the browser (by specifying the `spec` URL parameter, as shown above). For this case, you may provide the `timeout` URL paramter (takes precedence over `Netzke::Testing.js_timeout`):

    http://localhost:3000/netzke/components/UserGrid?spec=user_grid&timeout=10

## Asynchronous helpers

Asynchronous helpers like `wait` can either call the provided callback function, or (if none was provided) return a promise, so you can do:

    wait().
    .then ->
      doSomething()
      wait()
    .then
      doSomeMore()

## Requirements

* Ruby >= 1.9.3
* Rails ~> 4.2.0
* Ext JS = 5.1.0

---
© 2015 [Max Gorin](https://twitter.com/mxgrn), released under the MIT license (see LICENSE).

**Note** that Ext JS is licensed [differently](http://www.sencha.com/products/extjs/license/), and you may need to
purchase a commercial license in order to use it in your projects!
