module Netzke::Testing::Helpers
  def run_mocha_spec(path, options = {})
    component = options[:component] || path.camelcase
    locale = options[:locale]
    url = netzke_components_path(class: component, spec: path)
    url << "&locale=#{locale}" if locale

    visit url

    # Wait while the test is running
    wait_for_javascript

    assert_mocha_results
  end

  def wait_for_javascript
    start = Time.now
    loop do
      page.execute_script("return Netzke.mochaDone;") ? break : sleep(0.1)

      # no specs are supposed to run longer than 10 seconds
      raise "Timeout running JavaScript specs for #{component}" if Time.now > start + 10.seconds
    end

  rescue Selenium::WebDriver::Error::JavascriptError => e
    # give some time for visual examination of the problem
    # (TODO: make configurable)
    sleep 5

    raise e
  end

  def assert_mocha_results
    success = page.execute_script(<<-JS)
      var stats = Netzke.mochaRunner.stats;
      return stats.failures == 0 && stats.tests !=0
    JS

    if !success
      # give some time for visual examination of the problem
      # (TODO: make configurable)
      sleep 5

      raise "JS expectations failed"
    end
  end
end
