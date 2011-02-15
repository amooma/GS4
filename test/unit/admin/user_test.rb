require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should "be valid build" do
    assert Factory.build(:user).valid?
  end
  should "not be valid with .new" do
    assert !User.new.valid?
  end
  should "not be valid with nil username" do
    assert !Factory.build(:user, :username => nil).valid?
  end
  should "not be valid with nil password" do
    assert !Factory.build(:user, :password => nil).valid?
  end
  should "not be valid with nil email" do
    assert !Factory.build(:user, :email => nil).valid?
  end
  should "be valid with nil gn" do
    assert Factory.build(:user, :gn => nil).valid?
  end
  should "be valid with nil sn" do
    assert Factory.build(:user, :sn => nil).valid?
  end
  should "not be valid when username not unique" do
    user = Factory.create(:user)
    assert !Factory.build(:user, :username => user.username).valid?
  end
  should "not be valid when email not unique" do
    user = Factory.create(:user)
    assert !Factory.build(:user, :email => user.email).valid?
  end
end
