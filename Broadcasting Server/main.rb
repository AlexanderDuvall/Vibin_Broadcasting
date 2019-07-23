#Sends data to dedicated server
puts "Broadcaster Streaming Started..."
require_relative '../Broadcasting Server/Server'
ip = "192.168.1.73"
puts ip
@server = Server.new(ip,'4444')
@server.run