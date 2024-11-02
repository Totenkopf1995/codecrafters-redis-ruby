require "socket"
class YourRedisServer
  def initialize(port)
    @port = port
  end
  def resp_encoder(message)
    "#{message}\r\n"
  end
  def resp_decode(raw_command)
    parts = raw_command.split("\r\n")
    parts[2]
  end
  def read_resp_array(client)
    array_length = client.gets[1..-3].to_i
    array = [];
    array_length.times do
      length_prefix = client.gets
      length = length_prefix[1..-3].to_i
      value = client.gets.strip[0...length]
      array << value
    end
    array
  end
  def handle_client(client)
    loop do
      command_array = read_resp_array(client)
      break if command_array.empty?
      command = command_array.first.upcase
      case command
      when "PING"
        client.puts(resp_encoder("+PONG"))
      else
        client.puts(resp_encoder("-ERR unknown command '#{command}'"))
      end
    end
    client.close
  end
  def start
    # You can use print statements as follows for debugging, they'll be visible when running tests.
    puts("Logs from your program will appear here!")
    # Uncomment this block to pass the first stage
    server = TCPServer.new(@port)
    loop do
      client = server.accept
      handle_client(client)
    end
  end
end
YourRedisServer.new(6379).start