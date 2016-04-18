#!/usr/bin/ruby -w

$:.unshift File.expand_path('../lib', File.dirname(__FILE__))

require 'ifconfig'

cfg = IfconfigWrapper.new().parse

puts cfg
