require_relative 'requests'
require_relative '../Dedicated_Server/Server'
#listen to requests
@dedicated_server = Server.new('192.168.1.91', 4445)
server = Thread.new do |f|
  @dedicated_server.run
end
requests = Thread.new do
  unless (@dedicated_server.nil?)
    requests_server = Requests.new '192.168.1.91', '4446', @dedicated_server
  else
    puts "nil....."
  end
end
server.join
requests.join

