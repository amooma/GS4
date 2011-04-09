require 'test_helper'

class VoicemailServerTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build( :voicemail_server ).valid?
  end
  
  should "not be valid with .new" do
    assert ! VoicemailServer.new.valid?
  end
  
  
  # valid host
  [
    '10.0.0.0',
    'www.amooma.de',
    '2001:0db8:85a3:0000:0000:8a2e:0370:7334',
    '2001:0db8:0000:08d3:0000:8a2e:0070:7344',
    '2001:db8:0:8d3:0:8a2e:70:7344',
    '2001:db8:0:0:0:0:1428:57ab',
    '2001:db8::1428:57ab',
    '2001:db8:0:0:8d3:0:0:0',
    '2001:db8:0:0:8d3::',
    '2001:db8::8d3:0:0:0',
    '2001:0db8:1234::',
    '::',  # should this be valid? (valid IPv6 address, but this is the "unspecified" address)
    '::1', # loopback
    'fe80::',  # link-local unicast
    'fec0::',  # site-local unicast
    'fc00::',  # unique local unicast
    'fd9e:21a7:a92c:2323::1',  # unique local unicast
    'ff00::',  # multicast
    '192.0.2.128',
    '::ffff:192.0.2.128',
    '::ffff:c000:280',
    'example.com123',
    'abc',
    'abc.',
  ].each { |host|
    should "be valid with host #{host.inspect}" do
      assert Factory.build( :voicemail_server, :host => host ).valid?
    end
  }
  
  # invalid host
  [
    nil,
    '',
    ' ',
    '10.0.x.0',
    'www.amooma.01',
    '2001:0xb8:85a3:0000:0000:8a2e:0370:7334',
    '2001:db8::8d3::',
    '2001:0000:85a3:0000:0000:8a2e:0370:73340',
    '::ffff:192.0.2.128.123',
    'example.123com',
    '123',
    '.',
    ' abc',
    'abc ',
    '[',
    'abc.[',
    'a c',
    'a#c',
    '_',
    '_c',
    'a_c',
  ].each { |host|
    should "not be valid with host #{host.inspect}" do
      assert ! Factory.build( :voicemail_server, :host => host ).valid?
    end
  }
  
  
  # valid port
  [
    1,
    65535,
    nil,
    '',
  ].each { |port|
    should "be valid with port #{port.inspect}" do
      assert Factory.build( :voicemail_server, :port => port ).valid?
    end
  }
  
  # invalid port
  [
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with port #{port.inspect}" do
      assert ! Factory.build( :voicemail_server, :port => port ).valid?
    end
  }
  
  
  # valid management_host
  [
    '10.0.0.0',
    'www.amooma.de',
  ].each { |host|
    should "be valid with management_host #{host.inspect}" do
      valid_management_port = 123
      assert Factory.build( :voicemail_server, :management_host => host, :management_port => valid_management_port ).valid?
    end
  }
  
  # invalid management_host
  [
    '123',
  ].each { |host|
    should "not be valid with management_host #{host.inspect}" do
      valid_management_port = 123
      assert ! Factory.build( :voicemail_server, :management_host => host, :management_port => valid_management_port ).valid?
    end
  }
  
  
  # valid management_port
  [
    1,
    65535,
  ].each { |port|
    should "be valid with management_port #{port.inspect}" do
      valid_management_host = "foo.localdomain"
      assert Factory.build( :voicemail_server, :management_port => port, :management_host => valid_management_host ).valid?
    end
  }
  
  # invalid management_port
  [
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with management_port #{port.inspect}" do
      valid_management_host = "foo.localdomain"
      assert ! Factory.build( :voicemail_server, :management_port => port, :management_host => valid_management_host ).valid?
    end
  }
  
  
  # invalid with management_port without management_host
  [
    nil,
    '',
  ].each { |host|
    should "not be valid with management_port if management_host is not set" do
      valid_management_port = 123
      assert ! Factory.build( :voicemail_server, :management_host => host, :management_port => valid_management_port ).valid?
    end
  }
  
  # invalid with management_host without management_port
  [
    nil,
    '',
  ].each { |port|
    should "not be valid with management_host if management_port is not set" do
      valid_management_host = "foo.localdomain"
      assert ! Factory.build( :voicemail_server, :management_port => port, :management_host => valid_management_host ).valid?
    end
  }
  
  
  
  should "not be valid when host and port not unique" do
    voicemail_server = Factory.create(:voicemail_server, :port => 3000)
    assert ! Factory.build( :voicemail_server, :host => voicemail_server.host, :port => voicemail_server.port ).valid?
  end
  
  should "not be valid when host and port not unique (case-insensitive)" do
    voicemail_server = Factory.create( :voicemail_server, :host => "abc.localdomain", :port => 3000 )
    assert ! Factory.build( :voicemail_server, :host => voicemail_server.host.swapcase, :port => voicemail_server.port ).valid?
  end
  
  should "be valid when host not unique" do
    voicemail_server = Factory.create(:voicemail_server, :port => 3000)
    assert Factory.build( :voicemail_server, :host => voicemail_server.host, :port => voicemail_server.port + 1 ).valid?
  end
  
  should "be valid when host not unique (case-insensitive)" do
    voicemail_server = Factory.create( :voicemail_server, :host => "abc.localdomain", :port => 3000 )
    assert Factory.build( :voicemail_server, :host => voicemail_server.host.swapcase, :port => voicemail_server.port + 1 ).valid?
  end
  
end
