require 'test_helper'

class SubscriberTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build( :subscriber ).valid?
  end
  
  should "not be valid with .new" do
    assert ! Subscriber.new.valid?
  end
  
  should "not be valid with nil username" do
    assert ! Factory.build( :subscriber, :username => nil ).valid?
  end
  
  should "not be valid with nil domain" do
    assert ! Factory.build( :subscriber, :domain => nil ).valid?
  end
  
  should "be valid with nil password" do
    assert Factory.build( :subscriber, :password => nil ).valid?
  end
  
  should "be valid with nil email_address" do
    assert Factory.build( :subscriber, :email_address => nil ).valid?
  end
  
  should "be valid with nil ha1" do
    assert Factory.build( :subscriber, :ha1 => nil ).valid?
  end 
  
  should "be valid with nil ha1b" do
    assert Factory.build( :subscriber, :ha1b => nil ).valid?
  end
  
  should "be valid with nil rpid" do
    assert Factory.build( :subscriber, :rpid => nil ).valid?
  end
  
  should "not be valid when username and domain not unique" do
    subscriber = Factory.create( :subscriber )
    assert ! Factory.build( :subscriber, {
      :username => subscriber.username,
      :domain   => subscriber.domain,
    }).valid?
  end 
  
end
