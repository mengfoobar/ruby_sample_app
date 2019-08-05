require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @main_user = users(:michael)
    @secondary_user = users(:henry)
  end

  test "unsuccessful edit" do
    log_in_as(@main_user)
    get edit_user_path(@main_user)
    assert_template 'users/edit'
    patch user_path(@main_user), params: { user:{ name:"",
                                             email: "foo@invalid",
                                             password: "foo",
                                             password_confirmation: "bar"}}
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@main_user)
    get edit_user_path(@main_user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@main_user), params: { user: {name: name,
                                             email: email,
                                             password: "",
                                             password_confirmation: ""
    }}
    assert_not flash.empty?
    assert_redirected_to @main_user
    @main_user.reload
    assert_equal name, @main_user.name
    assert_equal email, @main_user.email
  end

  test "user can't access edit while logged out" do
    get edit_user_path(@main_user)
    assert_not flash[:danger].empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@main_user), params: {user: { name: @main_user.name,
                                             email: @main_user.email
    }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

end
