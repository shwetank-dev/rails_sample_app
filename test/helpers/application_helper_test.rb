require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    base_title = "Ruby on Rails Tutorial Sample App"
    assert_equal base_title, full_title
    assert_equal "Help | #{base_title}", full_title('Help')
  end
end

require "test_helper"

class RememberLoginTest < ActionView::TestCase
  # def setup
  #   @users = users(:michael)
  #   remember(@user)
  # end

  # test "current_user returns right user when session is nil" do
  #   assert_equal @user, current_user
  #   assert is_logged_in?
  # end

  # test "current_user returns nil when remember_digest is wrong" do
  #   @user.update_attribute(:remember_digest, User.digest(User.new_token))
  #   assert_nil current_user
  # end
end