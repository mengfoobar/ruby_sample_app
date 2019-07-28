require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: { user: {
          name: "",
          email: "user@invalid",
          password: "foo",
          password_confirmation: "bar"
      }}
    end
  end

  test "valid signup information" do
    get signup_path

    # TODO: verify if these all run asynchronously like nodejs async

    post users_path, params: { user: {
        name: "Henry Lao",
        email: "user@valid.com",
        password: "foobar",
        password_confirmation: "foobar"
    }}

    assert_equal User.count, 2
    follow_redirect! #TODO; hella magical. look into
    assert_template 'users/show'
    assert is_logged_in?

  end
end
