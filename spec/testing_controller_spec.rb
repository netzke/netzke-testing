require 'spec_helper'

feature Netzke::TestingController do
  it 'renders Netzke components specified in the URL' do
    visit '/netzke/components/Foo'
    page.should have_selector "#foo-netzke"
  end
end
