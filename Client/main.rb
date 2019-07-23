require_relative 'requests'
require_relative '../Dedicated_Server/Server'
require_relative '../Rails Display Server/DisplayListener'
#listen to requests
ip = Socket.ip_address_list.detect {|intf| intf.ipv4_private?}
ip = ip.ip_address
return_address = "192.168.1.70"
@dedicated_server = Server.new(ip, 4445,return_address)

server = Thread.new do |f|
  @dedicated_server.run
end
requests = Thread.new do
  unless (@dedicated_server.nil?)
    requests_server = Requests.new ip, '4446', @dedicated_server, return_address
  else
    puts "nil....."
  end
end
display = Thread.new do
  unless @dedicated_server.nil?
    display_server = DisplayListener.new ip, '4447', @dedicated_server
    display_server.run
  end
end
server.join
requests.join
display.join
