require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = 'a' * 55
    assert_not @user.valid?
  end

  test "email validation should accept valid email" do
    valid_addresses = %w[user@example.com USER@foo.com first.last@foo.jp]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.  foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email address must be unique" do
    new_user_1 = User.new(name: "new_user_1", email: @user.email)

    @user.save

    assert_not new_user_1.valid?
  end

  test "email should be saved as downcase" do
    upper_case_email = "FOO@BAR.COM"
    @user.email = upper_case_email
    @user.save
    assert_equal upper_case_email.downcase, @user.reload.email
  end

test "password and password_confirmation validations" do
  # blank password
  @user.password = @user.password_confirmation = ""
  assert_not @user.valid?

  # mismatch
  @user.password = "foobar"
  @user.password_confirmation = "barbaz"
  assert_not @user.valid?

  # valid
  @user.password = @user.password_confirmation = "foobar"
  assert @user.valid?
end
end