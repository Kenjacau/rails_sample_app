require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
   def setup
    @user = users(:michael)
  end
  
  test "Login with invalid information" do
    
  #Visit the login path
  get login_path
  #Verify that the new sessions form renders properly
  assert_template 'sessions/new'
  #Post to the sessions form renders properly.
  post login_path, session: { email: "", password: ""}
  #Verify that the new sessions form gets re-rendered and that a flash message appears
  assert_template 'sessions/new'
  assert_not flash.empty?
  #Visit another page (such as the Home page).
  get root_path
  #Verify that the flash message doesn’t appear on the new page.
  assert flash.empty?
end

test "login with valid information followed by logout" do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
     # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
  
  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_nil cookies['remember_token']
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
