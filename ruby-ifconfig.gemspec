# -*- encoding: utf-8 -*-
 
Gem::Specification.new do |s|
  s.name = %q{ruby-ifconfig}
  s.version = "1.3.0"
  s.date = %q{2014-01-01}
  s.authors = ["Daniel Hobe", "Alex Peuchert", "Ali Jelveh", "Alan Somers"]
  s.email = %q{asomers@freebsd.org}
  s.homepage = %q{http://github.com/asomers/ruby-ifconfig}

  s.description = %q{Ruby wrapper around the ifconfig command.}
  s.summary = %q{This is a Ruby wrapper around the ifconfig command.  The goal is to make getting any information that ifconfig provides easy to access.}

  s.has_rdoc = true
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["INSTALL", "README", "Changelog", "TODO", "COPYING"]
 
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=

  s.require_paths = ["lib"]
  s.files = %w[
    lib/ifconfig/sunos/interface_types.rb
    lib/ifconfig/sunos/ifconfig.rb
    lib/ifconfig/sunos/network_types.rb
    lib/ifconfig/bsd/interface_types.rb
    lib/ifconfig/bsd/ifconfig.rb
    lib/ifconfig/bsd/network_types.rb
    lib/ifconfig/linux/interface_types.rb
    lib/ifconfig/linux/ifconfig.rb
    lib/ifconfig/linux/network_types.rb
    lib/ifconfig/common/interface_types.rb
    lib/ifconfig/common/ifconfig.rb
    lib/ifconfig/common/network_types.rb
    lib/ifconfig.rb
    Rakefile
  ]

  s.test_files = %w[
    test/selftest.rb
    test/test_helper.rb
    test/unit/tc_openbsd.rb
    test/unit/tc_dragonflybsd.rb
    test/unit/tc_linux.rb
    test/unit/tc_freebsd.rb
    test/unit/tc_netbsd.rb
    test/unit/tc_darwin.rb
    test/unit/tc_sunos.rb
    test/unit/tc_osx.rb
    ifconfig_examples/darwin.txt
    ifconfig_examples/dragonflybsd.txt
    ifconfig_examples/dragonflybsd_netstat.txt
    ifconfig_examples/netbsd.txt
    ifconfig_examples/netbsd_netstat.txt
    ifconfig_examples/freebsd_netstat.txt
    ifconfig_examples/linux.txt
    ifconfig_examples/linux_ethernet.txt
    ifconfig_examples/freebsd.txt
    ifconfig_examples/openbsd.txt
    ifconfig_examples/sunos.txt
    ifconfig_examples/sunos_netstat.txt
    ifconfig_examples/osx.txt
  ]
 
end
 
