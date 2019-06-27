require 'sockets'
require_relative '../Dedicated_Server/Server'
class Requests
  def initialize(ip_v4, port)
    server = TCPServer.new ip_v4, port
    current_client = server.accept
    Thread.start(current_client) do |client|
      lines client.readpartial(2048)
      request = receive lines
      if (request.key? "GETINFO" && !request["GETINFO"].nil?)

      end
    end
  end
end