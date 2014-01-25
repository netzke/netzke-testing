require 'spec_helper'

feature "Foo", js: true do
  it 'runs JS specs' do
    run_mocha_spec "foo"
  end
end
