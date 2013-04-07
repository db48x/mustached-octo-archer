require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get player" do
    get :player
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
