# $Id: interface_types.rb,v 1.1.1.1 2005/07/02 19:10:58 hobe Exp $
#
require 'ifconfig/common/interface_types'

class NetworkAdapter
  # becuase on *BSD we get activity from netstat
  # we need to have a way to set this:
  attr_writer :mtu

  # iterate line by line and dispatch to helper functions
  # for lines that match a pattern
  #
  def parse_ifconfig(netstattxt=nil)
    @ifconfig.split("\n").each { |line|
      case line
        when /^\s+#{@protos}/
          add_network(line)
        when /flags\=/i
          parse_flags(line)
        when /\s*fib:/
          parse_fib(line)
        when /\s*media:/
          parse_media(line)
      end
    }
  end

  # parses the "fib: 1" line
  def parse_fib(line)
    @fib = line.split()[1].to_i
  end

  # parses the "UP LOOPBACK RUNNING  MTU:3924  Metric:1" line
  #
  def parse_flags(line)
    flags = line.match(/\<(\S+)\>/i)[1]
    @flags = flags.strip.split(',')
    @status = true if @flags.include?('UP')
  end

  # Parses networks on an interface based on the first token in the line.
  # eg: inet or inet6
  #
  def add_network(line)
    case line
      when /^\s+inet\s/
        addr,mask = line.match(/\s+([\d\d?\d?\.]{4,})\s+netmask\s+(\S+)/i)[1..2]
        bcast = line.match(/\s+broadcast\s([\d\d?\d?\.]{4,})/i)
        bcast = bcast[1] unless bcast.nil?
        @networks['inet'] = Ipv4Network.new(addr, mask, bcast)
      when /^\s+inet6\s/
        # there can be multiple inet6 entries
        begin
          addr,scope = line.match(/inet6\s+(\S+)%/i)[1]
        rescue NoMethodError
          addr,scope = line.match(/inet6\s+(\S+)/i)[1]
        end
        @networks["inet6:#{addr}"] = Ipv6Network.new(addr)
      else
        puts "unknown network type: #{line}"
    end
  end
end


class EthernetAdapter
  # Parses the "media: Ethernet autoselect (1000baseT <full-duplex>)" line
  def parse_media(line)
    match = line.match /Ethernet (autoselect )?(\()?(\S+?)[ )]/
    if match
      @media = match[3]
    end
  end

  def set_mac
    begin
      match=@ifconfig.match(/\s+ether\s+([a-f\d]{1,2}(?:\:[a-f\d]{1,2}){5})/im)
      return match[1] unless match.nil?
      # Openbsd
      match = @ifconfig.match(/\s+address\:\s+([a-f\d]{1,2}(?:\:[a-f\d]{1,2}){5})/im)
      return match[1] unless match.nil?
    rescue NoMethodError
      puts "Couldn't Parse MAC Address for: "+@name
    end
  end
end
