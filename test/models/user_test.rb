require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "John", 
                      email: "john@example.com", 
                      password: "password", 
                      password_confirmation: "password"
                    )
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "name should be less than 30 characters" do
    @user.name = "a" * 31
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

   test "email should not be longer than 255 characters" do
    @user.email = "a" * 246 + "@example.com"
    assert_not @user.valid?
  end

  test "email should accept a correct format" do
    valid_emails = %w[ 
                      user@example.com 
                      USER@example.com 
                      U.user@example.com.org
                      user+user@exa.com.es
                    ]

    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "should reject invalid emails" do
    invalid_emails = %w[
                        user@example
                        user@example,com
                        user@example.
                        user@example+example.com
                      ]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should not be valid"
    end              
  end

  test "email should be unique and case insensitive" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email should be lower case before being save in the DB" do
    mixed_email = "UseR@exAmple.com"
    @user.email = mixed_email
    @user.save

    assert_equal mixed_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end

  test "password should be at least 5 characters" do
    @user.password = @user.password_confirmation = "x" * 3
    assert_not @user.valid?
  end
end
