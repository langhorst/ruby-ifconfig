#!/usr/bin/ruby -w

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'ifconfig'
require 'pp'

ifcfg = IO.readlines(File.expand_path('../../ifconfig_examples/freebsd.txt', __FILE__)).join
netstat = IO.readlines(File.expand_path('../../ifconfig_examples/freebsd_netstat.txt', __FILE__)).join

ifconfig = IfconfigWrapper.new('BSD',ifcfg,netstat).parse

puts "Interfaces: (ifconfig.interfaces)"
pp ifconfig.interfaces

puts "\nrl0 mac address: (ifconfig['rl0'].mac)"
pp ifconfig['rl0'].mac

puts "\nIpV4 addresses on rl0: (ifconfig['rl0'].addresses('inet'))"
pp ifconfig['rl0'].addresses('inet')

puts "\nAll addresses reported by ifconfig: (ifconfig.addresses)"
pp ifconfig.addrs_with_type

puts "\nList of address types for rl0: (ifconfig['rl0'].addr_types)"
pp ifconfig['rl0'].addr_types

puts "\niconfig.each { block }"
ifconfig.each do |iface|
  pp iface.name if iface.up?
end

puts
s = ifconfig.to_s
puts s
