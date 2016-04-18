require File.expand_path('../test_helper', File.dirname(__FILE__))

class TC_DragonFlyBSDTest < Test::Unit::TestCase
  def setup
    sample = IO.readlines("#{File.dirname(__FILE__)}"+
                          "/../../ifconfig_examples/dragonflybsd.txt").join
    netstat_sample = IO.readlines("#{File.dirname(__FILE__)}"+
                          "/../../ifconfig_examples/dragonflybsd_netstat.txt").join
    @cfg = IfconfigWrapper.new('BSD',sample, netstat_sample).parse
  end

  def test_interface_list
    assert(@cfg.interfaces.sort == ["rl0", "lo0"].sort,
           "Failed to parse all interfaces")
  end

  def test_mac_parse
    assert(@cfg['rl0'].mac == "00:02:44:8f:bb:15",
    "Failed to parse MAC address: "+@cfg['rl0'].mac)
  end

  def test_flags
    assert(@cfg['rl0'].flags.include?('BROADCAST') &&
          @cfg['rl0'].flags.include?('RUNNING') &&
          @cfg['rl0'].flags.include?('MULTICAST') &&
          @cfg['rl0'].up?,
           "FLAG Parsing failed: #{@cfg['rl0'].flags}")
  end

  def test_addr_types
    assert(@cfg['rl0'].addr_types.include?('inet') &&
           @cfg['rl0'].addr_types.include?('inet6'),
           "Failed to parse all address types")
  end

  def test_attribs
    assert(@cfg['rl0'].rx['bytes'].class == Fixnum || NilClass &&
           @cfg['rl0'].tx['bytes'].class == Fixnum || NilClass, "Wrong class")

  end

  def test_capabilities
    expected = %w(RXCSUM TXCSUM VLAN_MTU VLAN_HWTAGGING)
    assert_equal(expected.sort, @cfg['rl0'].capabilities.sort)
  end

end
