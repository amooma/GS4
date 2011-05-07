require 'test_helper'

class SipAccountTest < ActiveSupport::TestCase
  
  # test sip_account without external servers
  
  
  should "have a valid factory setup" do
    assert Factory.build( :sip_account ).valid?
  end
  
  # test that two factories in a row work
  should "have a valid factory setup for two factories in a row" do
    Factory.create(:sip_account)
    assert Factory.build( :sip_account ).valid?
  end
  
  
  # invalid auth_name
  #
  [
    '%A',
    '%XX',
    '%Ff',
  # "-A-\x00-B-",   # TODO - Enable this test once the bug has been solved: ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes. https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/6606
  # "\x00",         #TODO - Enable this test once the bug has been solved: ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes. https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/6606
    '\\',
    '"',
    'x' * 256,
  ].each { |username|
    should "not be possible to set auth_name to #{username.inspect}" do
      assert ! Factory.build( :sip_account, :auth_name => username ).valid?
    end
  }
  
  # valid auth_name
  #
  [
    'elvis',
    'Elvis123',
    '-_.!~*\'()',
    '%FF',
    '&=+$,;?/',
  ].each { |username|
    should "be possible to set auth_name to #{username.inspect}" do
      assert Factory.build( :sip_account, :auth_name => username ).valid?
    end
  }
  # valid password
  #
  [
    nil,
    '',
    'ABCabc012',
    '-_.!~*\'()',
    '&=+$,',
    '%00',
    '%20',
    '%FF',
  ].each { |password|
    should "be possible to set password to #{password.inspect}" do
      assert Factory.build( :sip_account, :password => password ).valid?
    end
  }
  
  # invalid password
  #
  [
    '%2',
    '%XX',
    '%ff',
    '%Ff',
    '%',
    '%%%',
    '"',
    ':',
    '#',
    '\\',
    'x' * 256,
  ].each { |password|
    should "not be possible to set password to #{password.inspect}" do
      assert ! Factory.build( :sip_account, :password => password ).valid?
    end
  }
  
  
  should "not be possible to set sip_server_id to nil" do
    assert ! Factory.build( :sip_account, :sip_server_id => nil ).valid?
  end
  
  should "not be possible to set a sip_server_id that does not exist" do
    sip_server = Factory.create( :sip_server )
    sip_server_id = sip_server.id
    sip_server.destroy
    assert ! Factory.build( :sip_account, :sip_server_id => sip_server_id ).valid?
  end
  
  
  should "not be possible to set sip_proxy_id to nil" do
    assert ! Factory.build( :sip_account, :sip_proxy_id => nil ).valid?
  end
  
  should "not be possible to set a sip_proxy_id that does not exist" do
    sip_proxy = Factory.create( :sip_proxy )
    sip_proxy_id = sip_proxy.id
    sip_proxy.destroy
    assert ! Factory.build( :sip_account, :sip_proxy_id => sip_proxy_id ).valid?
  end
  
  
  should "be possible to set voicemail_server_id to nil" do
    assert Factory.build( :sip_account, :voicemail_server_id => nil ).valid?
  end
  
  should "not be possible to set a voicemail_server_id that does not exist" do
    voicemail_server = Factory.create( :voicemail_server )
    voicemail_server_id = voicemail_server.id
    voicemail_server.destroy
    assert ! Factory.build( :sip_account, :voicemail_server_id => voicemail_server_id ).valid?
  end
  
  
  should "be possible to set phone_id to nil" do
    assert Factory.build( :sip_account, :phone_id => nil ).valid?
  end
  
  should "not be possible to set a phone_id that does not exist" do
    phone = Factory.create( :phone )
    phone_id = phone.id
    phone.destroy
    assert ! Factory.build( :sip_account, :phone_id => phone_id ).valid?
  end
  
  
  should "be possible to set user_id to nil" do
    assert Factory.build( :sip_account, :user_id => nil ).valid?
  end
  
  should "not be possible to set a user_id that does not exist" do
    user = Factory.create( :user )
    user_id = user.id
    user.destroy
    assert ! Factory.build( :sip_account, :user_id => user_id ).valid?
  end
  
  
end

