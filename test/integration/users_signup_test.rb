require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "should get a signup url" do
    get signup_path
    assert_response :success
  end
end
