require File.expand_path('../test_helper', File.dirname(__FILE__))

class TC_FreeBSDTest < Test::Unit::TestCase
  def setup
    ifconfig_sample = IO.readlines("#{File.dirname(__FILE__)}"+
                                   "/../../ifconfig_examples/freebsd.txt").join
    netstat_sample = IO.readlines("#{File.dirname(__FILE__)}"+
                                  "/../../ifconfig_examples/freebsd_netstat.txt").join
    @cfg = IfconfigWrapper.new('BSD',ifconfig_sample, netstat_sample).parse
  end

  def test_interface_list
    assert(@cfg.interfaces.sort == ["igb0", "igb1", "igb2", "igb3",
                                    "lo0", "lagg0"].sort,
           "Failed to parse all interfaces")
  end

  def test_mac_parse
    assert(@cfg['igb0'].mac == "00:11:22:33:44:55",
    "Failed to parse MAC address: "+@cfg['igb0'].mac)
  end

  def test_flags
    assert(@cfg['igb0'].flags.include?('BROADCAST') &&
          @cfg['igb0'].flags.include?('RUNNING') &&
          @cfg['igb0'].flags.include?('MULTICAST') &&
          @cfg['igb0'].up?,
           "FLAG Parsing failed: #{@cfg['igb0'].flags}")
  end

  def test_addr_types
    assert(@cfg['igb0'].addr_types.include?('inet') &&
           @cfg['igb0'].addr_types.include?('inet6'),
           "Failed to parse all address types")
  end

  def test_attribs
    assert(@cfg['igb0'].rx['bytes'].class == Fixnum || NilClass &&
           @cfg['igb0'].tx['bytes'].class == Fixnum || NilClass, "Wrong class")
    assert_equal(1683211, @cfg['igb0'].rx['packets'])
    assert_equal(0, @cfg['igb0'].rx['errors'])
    assert_equal(1480096, @cfg['igb0'].tx['packets'])
    assert_equal(0, @cfg['igb0'].tx['errors'])
  end

  def test_mtu
    assert_equal(1500, @cfg['igb0'].mtu)
    assert_equal(1500, @cfg['lagg0'].mtu)
    assert_equal(16384, @cfg['lo0'].mtu)
  end

end
