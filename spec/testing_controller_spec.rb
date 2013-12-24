require 'spec_helper'

feature Netzke::TestingController do
  it 'renders Netzke components specified in the URL' do
    visit '/netzke/components/Foo'
    page.should have_selector "#foo-netzke"
  end

  it 'includes custom js into page' do
    visit '/netzke/components/Foo?spec=true'
    page.html.should include '<script src="/assets/custom.js"'
  end

  it 'includes JS helpers' do
    visit '/netzke/components/Foo?spec=true'
    page.html.should include 'assets/netzke/testing/helpers/queries'
  end

  it 'does not include JS helpers when no spec is specified' do
    visit '/netzke/components/Foo'
    page.html.should_not include 'assets/netzke/testing/helpers/queries'
  end

  it 'does not include JS helpers when no-helper param is set to true' do
    visit '/netzke/components/Foo?no-helpers=true&spec=true'
    page.html.should_not include 'assets/netzke/testing/helpers/queries'
  end
end
