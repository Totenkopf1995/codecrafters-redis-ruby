require "socket"

class YourRedisServer
  def initialize(port)
    @port = port
  end

  def start
    puts("Logs from your program will appear here!")

    server = TCPServer.new(@port)
    client = server.accept

    while (data = client.gets&.chomp) do
      if data == 'PING'
        client.puts("+PONG\r\n")
      else
        client.puts("-ERR unknown command\r\n")
      end
    end
  end
end

YourRedisServer.new(6379).start