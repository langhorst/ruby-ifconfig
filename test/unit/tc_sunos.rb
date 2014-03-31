require File.expand_path('../test_helper', File.dirname(__FILE__))

class TC_SunOSTest < Test::Unit::TestCase
  def setup
    sample = IO.readlines("#{File.dirname(__FILE__)}"+
                          '/../../ifconfig_examples/sunos.txt').join
    netstat_sample = IO.readlines("#{File.dirname(__FILE__)}"+
                                  "/../../ifconfig_examples/sunos_netstat.txt").join
    @cfg = IfconfigWrapper.new('SunOS',sample,netstat_sample).parse
  end

  def test_interface_list
    assert(@cfg.interfaces.sort == ["le1", "lo0", "bge0"].sort,
           "Failed to parse all interfaces")
  end

  def test_mac_parse
    assert(@cfg['bge0'].mac == "0:3:ba:42:9d:ef", 
    "Failed to parse MAC address: "+@cfg['bge0'].mac)
  end

  def test_flags
    assert(@cfg['bge0'].flags.include?('BROADCAST') &&
          @cfg['bge0'].flags.include?('RUNNING') &&
          @cfg['bge0'].flags.include?('MULTICAST') &&
          @cfg['bge0'].up?,
           "FLAG Parsing failed: #{@cfg['bge0'].flags}")
  end

  def test_addr_types
    assert(@cfg['bge0'].addr_types.include?('inet') &&
           @cfg['bge0'].addr_types.include?('inet6'),
           "Failed to parse all address types")
  end

  def test_networks
    assert(@cfg['bge0'].addr_types.include?('inet') &&
           @cfg['bge0'].addr_types.include?('inet6'),
           "Missing Address Types: #{@cfg['bge0'].addr_types}")
  end

  def test_attribs
    assert(@cfg['bge0'].rx['bytes'].class == Fixnum || NilClass&&
           @cfg['bge0'].tx['bytes'].class == Fixnum || NilClass, "Wrong class")
  end

end
