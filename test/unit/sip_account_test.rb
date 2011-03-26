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
 

end

