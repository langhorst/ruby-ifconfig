#!/usr/bin/ruby -w

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'ifconfig'
require 'pp'

sample = IO.readlines(File.expand_path('../../ifconfig_examples/netbsd.txt', __FILE__)).join
ifconfig = IfconfigWrapper.new('BSD',sample).parse

puts "Interfaces: (ifconfig.interfaces)"
pp ifconfig.interfaces

puts "\ncs0 mac address: (ifconfig['cs0'].mac)"
pp ifconfig['cs0'].mac

puts "\nIpV4 addresses on cs0: (ifconfig['cs0'].addresses('inet'))"
pp ifconfig['cs0'].addresses('inet')

puts "\nAll addresses reported by ifconfig: (ifconfig.addresses)"
pp ifconfig.addrs_with_type

puts "\nList of address types for cs0: (ifconfig['cs0'].addr_types)"
pp ifconfig['cs0'].addr_types

puts "\niconfig.each { block }"
ifconfig.each do |iface|
  pp iface.name if iface.up?
end

puts
s = ifconfig.to_s
puts s
