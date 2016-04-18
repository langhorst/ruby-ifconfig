# $Id: ifconfig.rb,v 1.1.1.1 2005/07/02 19:10:58 hobe Exp $
#
require 'ifconfig/common/ifconfig'
require 'ifconfig/bsd/network_types'
require 'ifconfig/bsd/interface_types'

class Ifconfig
  #
  # ifconfig = user provided ifconifg output
  # netstat = same, but for netstat -in
  #
  # XXX On FreeBSD, "netstat -inb" will show byte _and_ packet statistics, but
  # on NetBSD and OpenBSD, it will show byte statistics only.  We use "-in"
  # instead of "-inb" for cross-platform compatibility.
  #
  @@ifcfg_cmd = "/usr/bin/env ifconfig -a"
  @@netstat_cmd = "/usr/bin/env netstat -in"
  def initialize(ifconfig=nil,netstat=nil,verbose=nil)
    @ifconfig = ifconfig
    @ifconfig ||= IO.popen(@@ifcfg_cmd){ |f| f.readlines.join }

    @netstat = netstat
    @netstat ||= IO.popen(@@netstat_cmd){ |f| f.readlines.join }

    @verbose = verbose

    @ifaces = {}
    split_interfaces(@ifconfig).each do |iface|
      iface_name = get_iface_name(iface)
      case iface
        when /^lo\d\:/im
          @ifaces[iface_name] = LoopbackInterface.new(iface_name,iface)
          parse_activity(iface_name)
        when /^lagg[0-9]:/
          # This clause is only matched on FreeBSD.  Other OSes have similar
          # drivers, for example agr(4) on NetBSD, but ruby-ifconfig does not
          # yet support them.
          @ifaces[iface_name] = LinkAggregation.new(iface_name,iface)
          parse_activity(iface_name)
        when /\s+media\:\s+Ethernet\s+/im
          @ifaces[iface_name] = EthernetAdapter.new(iface_name,iface)
          parse_activity(iface_name)
        when /\s+supported\smedia\:\s+none\s+autoselect\s+/im, /media\: autoselect/im
          # This clause is only matched on Darwin. This pattern will only be
          # matched on ethernet devices (won't match on fw0 or any other
          # interface I can see).
          @ifaces[iface_name] = EthernetAdapter.new(iface_name,iface)
          parse_activity(iface_name)
        else
          puts "Unknown Adapter Type: #{iface}" if @verbose
      end
    end
  end

  # Parse activity on interface
  #
  # Not doing it in each interface class so we can pass in
  # fake input
  #
  def parse_activity(iface)
    mtu = rxpackets = rxerrors = txpackets = txerrors = 0
    fields = {}
    @netstat.split("\n").each { |line|
      line.strip!
      if line =~/^Name/
        headers = line.split(" ")
        headers.each_index {|i| fields[headers[i]] = i}
      elsif line =~ /^#{iface}/
        next if line.split[2] =~ /\<Link\#\d\>/
        puts "matched line for "+iface if @verbose
        toks = line.split
        mtu = toks[1]
        rxpackets += toks[fields["Ipkts"]].to_i
        rxerrors += toks[fields["Ierrs"]].to_i
        txpackets += toks[fields["Opkts"]].to_i
        txerrors += toks[fields["Oerrs"]].to_i
        @ifaces[iface].mtu = mtu.to_i
        @ifaces[iface].rx = { 'packets' => rxpackets,
                              'errors' => rxerrors }
        @ifaces[iface].tx = { 'packets' => txpackets,
                              'errors' => txerrors }
      end
    }
  end

end
