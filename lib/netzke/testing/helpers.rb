module Netzke::Testing::Helpers
  def run_mocha_spec(path, options = {})
    @component = options[:component] || path.camelcase
    locale = options[:locale]
    url = netzke_components_path(class: @component, spec: path)
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

      # no specs are supposed to run longer than 100 seconds
      raise "Timeout running JavaScript specs for #{@component}" if Time.now > start + 100.seconds
    end

  rescue Selenium::WebDriver::Error::JavascriptError => e
    # give some time for visual examination of the problem
    # sleep 5

    raise e
  end

  def assert_mocha_results
    result = page.execute_script(<<-JS)
      var runner = Netzke.mochaRunner;
      var errors = [];
      Ext.Array.each(runner.suite.suites[0].tests, function(t) { if (t.err) errors.push([t.title, t.err.toString()]) });
      return {
        test: runner.test.title,
        success: runner.stats.failures == 0 && runner.stats.tests !=0,
        error: runner.test.err && runner.test.err.toString(),
        errors: errors
      }
    JS

    if !result["success"]
      # give some time for visual examination of the problem
      # sleep 500

      errors = result["errors"].each_with_index.map do |(title, error), i|
        "#{i+1}) #{title}\n#{error}\n\n"
      end

      raise "Failures:\n#{errors.join}"
    end
  end
end
