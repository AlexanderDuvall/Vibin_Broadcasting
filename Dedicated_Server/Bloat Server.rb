require 'socket'
class BloatServer
  def initialize(ip_v4, port)
    @server = TCPServer.new ip_v4, port
    loop do
      puts "waiting for client"
      begin
        client = @server.accept
        puts "client found"
        request = client.readpartial(2048)
        lines = receive(request)
        if (!request.nil?)
          puts "incoming data: #{request}"
          Thread.start(client) do |c|
            loop do
              puts "looping"
              data = c.gets
              puts "Incoming Thread Data: #{data}"
              puts "Sending data Back..."
              #sends data back under this line
              c.puts "User_id:-1\nSong_id:-1"
            end
          end
        else
          puts "Incoming Data is null"
        end
      rescue Exception => e
        puts e.message
      end
    end
  end
end