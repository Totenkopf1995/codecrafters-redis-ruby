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
      if data.start_with?('*')
        command = parse_command(data)
        if command == 'PING'
          client.puts("+PONG\r\n")
        else
          client.puts("-ERR unknown command\r\n")
        end
      else
        client.puts("-ERR invalid format\r\n")
      end
    end
  end

  private

  def parse_command(data)
    if data == "*1\r\n$4\r\nPING\r\n"
      return 'PING'
    end

    nil
  end
end

YourRedisServer.new(6379).start