require "test_helper"

# Base class: shared setup + helpers, NO tests
class UsersLoginTestBase < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # Helper to log in as a specific user
  def log_in(email: @user.email, password: "password")
    post login_path, params: {
      session: {
        email: email,
        password: password
      }
    }
  end
end

# ---------------- Invalid login tests ----------------

class InvalidPasswordTest < UsersLoginTestBase
  test "login path renders new" do
    get login_path
    assert_template "sessions/new"
  end

  test "login with valid email and invalid password" do
    log_in(password: "invalid_password")
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end

# ---------------- Valid login tests ----------------

class ValidLoginTest < UsersLoginTestBase
  def setup
    super
    log_in # logs in @user with password "password"
  end

  test "redirect after login and layout links" do
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end

# ---------------- Logout tests ----------------

class LogoutTest < UsersLoginTestBase
  def setup
    super
    log_in
    delete logout_path
  end

  test "successful logout" do
    assert_not is_logged_in?
    assert_redirected_to root_url
  end

  test "redirect after logout and layout links" do
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end
end
