require 'test_helper'

class NetzkeTestingControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
