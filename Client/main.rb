require_relative 'requests'
require_relative '../Dedicated_Server/Server'
#listen to requests
ip = Socket.ip_address_list.detect {|intf| intf.ipv4_private?}
ip = ip.ip_address
puts ip
@dedicated_server = Server.new(ip, 4445)
server = Thread.new do |f|
  @dedicated_server.run
end
requests = Thread.new do
  unless (@dedicated_server.nil?)
    requests_server = Requests.new ip, '4446', @dedicated_server
  else
    puts "nil....."
  end
end
server.join
requests.join

