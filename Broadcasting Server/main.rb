#Sends data to dedicated server
puts "Broadcaster Streaming Started..."
require_relative '../Broadcasting Server/Server'
@server = Server.new('192.168.1.91', '4444')
@server.run