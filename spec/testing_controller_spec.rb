require 'spec_helper'

feature Netzke::TestingController do
  it 'renders Netzke components specified in the URL' do
    visit '/netzke/components/Foo'
    expect(page).to have_selector "#foo-netzke"
  end

  it 'includes JS helpers' do
    visit '/netzke/components/Foo?spec=true'
    expect(page.html).to include 'assets/netzke/testing/helpers/queries'
  end

  it 'does not include JS helpers when no spec is specified' do
    visit '/netzke/components/Foo'
    expect(page.html).to_not include 'assets/netzke/testing/helpers/queries'
  end

  it 'does not include JS helpers when no-helper param is set to true' do
    visit '/netzke/components/Foo?no-helpers=true&spec=true'
    expect(page.html).to_not include 'assets/netzke/testing/helpers/queries'
  end
end
