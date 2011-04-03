require 'test_helper'

class SipServerTest < ActiveSupport::TestCase
  
  should "be valid build" do
    assert Factory.build(:sip_server).valid?
  end
  
  should "not be valid with .new" do
    assert ! SipServer.new.valid?
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
      assert Factory.build( :sip_server, :host => host ).valid?
    end
  }
  
  # invalid host
  [
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
      assert ! Factory.build( :sip_server, :host => host ).valid?
    end
  }
  
   # valid port
  [
    1,
    65535,
  ].each { |port|
    should "be valid with management_port #{port.inspect}" do
      assert Factory.build( :sip_server, :management_port => port ).valid?
    end
  }
  
  # invalid port
  [
    '',
    nil,
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with management_port #{port.inspect}" do
      assert ! Factory.build( :sip_server, :management_port => port ).valid?
    end
  } 
  
  # valid management_host
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
      assert Factory.build( :sip_server, :management_host => host, :management_port => 1 ).valid?
    end
  }
  
  # invalid management_host
  [
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
      assert ! Factory.build( :sip_server, :management_host => host, :management_port => 1 ).valid?
    end
  }
  
  # valid management_port
  [
    1,
    65535,
  ].each { |port|
    should "be valid with management_port #{port.inspect}" do
      assert Factory.build( :sip_server, :management_host => 'example.com', :management_port => port ).valid?
    end
  }
  
  # invalid management_port
  [
    '',
    nil,
    'foo',
    -1,
    65536,
  ].each { |port|
    should "not be valid with management_port #{port.inspect}" do
      assert ! Factory.build( :sip_server, :management_host => 'example.com', :management_port => port ).valid?
    end
  }
  
  
  should "not be valid when not managed by gs but management_port given" do
    assert ! Factory.build( :sip_server, :management_port => 3000 ).valid?
  end
  
  
  should "not be valid when host and port not unique" do
    sip_server = Factory.create(:sip_server, :port => 3000)
    assert ! Factory.build( :sip_server, :host => sip_server.host, :port => sip_server.port ).valid?
  end
  
  should "not be valid when host and port not unique (case-insensitive)" do
    sip_server = Factory.create( :sip_server, :host => "abc.localdomain", :port => 3000 )
    assert ! Factory.build( :sip_server, :host => sip_server.host.swapcase, :port => sip_server.port ).valid?
  end
  
  should "be valid when host not unique" do
    sip_server = Factory.create(:sip_server, :port => 3000)
    assert Factory.build( :sip_server, :host => sip_server.host, :port => sip_server.port + 1 ).valid?
  end
  
  should "be valid when host not unique (case-insensitive)" do
    sip_server = Factory.create( :sip_server, :host => "abc.localdomain", :port => 3000 )
    assert Factory.build( :sip_server, :host => sip_server.host.swapcase, :port => sip_server.port + 1 ).valid?
  end
  
end
