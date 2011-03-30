require 'test_helper'

class SipAccountTest < ActiveSupport::TestCase
  # testing sip_account without external servers
  should "have a valid factory setup" do
    assert Factory.build( :sip_account ).valid?
  end
  
  # testing that two Factories in a row work
  should "have a valid factory setup for two Factories in a row" do
    Factory.create(:sip_account)
    assert Factory.build( :sip_account ).valid?
  end

  
  # valid extension
  [
    '123',
    '1',
    '123456',
  ].each { |extension|
    should "be valid with extension #{extension.inspect}" do
      assert Factory.build( :sip_account, :phone_number => extension ).valid?
    end
  }
  
  # invalid extension
  [
    nil,
    '',
    'foo',
    '12345678901',
    '123foo',
    '012foo',
    'foo123',
  # '01',
    '-',
    '+',
    -1,
    '-1',
    '-0',
  # '+10',
  ].each { |extension|
    should "not be valid with extension #{extension.inspect}" do
      assert ! Factory.build( :sip_account, :phone_number => extension ).valid?
    end
  }
  
  # invalid auth_name
  #
  [
    '%A',
    '%XX',
    '%Ff',
  # "-A-\x00-B-",   #FIXME - ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes. https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/6606
  # "\x00",         #FIXME - ActiveRecord's SQLite adapter has a bug and does not escape \x00 bytes. https://rails.lighthouseapp.com/projects/8994-ruby-on-rails/tickets/6606
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
  
  
  should "be possible to set sip_phone_id to nil" do
    assert Factory.build( :sip_account, :sip_phone_id => nil ).valid?
  end
  
  should "not be possible to set a sip_phone_id that does not exist" do
    sip_phone = Factory.create( :sip_phone )
    sip_phone_id = sip_phone.id
    sip_phone.destroy
    assert ! Factory.build( :sip_account, :sip_phone_id => sip_phone_id ).valid?
  end
  
  
  should "be possible to set extension_id to nil" do
    assert Factory.build( :sip_account, :extension_id => nil ).valid?
  end
  
  should "not be possible to set a sip_phone_id that does not exist" do
    extension = Factory.create( :extension )
    extension_id = extension.id
    extension.destroy
    assert ! Factory.build( :sip_account, :extension_id => extension_id ).valid?
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

