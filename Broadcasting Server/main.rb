#Sends data to dedicated server
puts "Broadcaster Streaming Started..."
require_relative '../Broadcasting Server/Server'
ip = Socket.ip_address_list.detect {|intf| intf.ipv4_private?}
ip = ip.ip_address
puts ip
@server = Server.new(ip, '4444')
@server.run