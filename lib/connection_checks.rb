module ConnectionChecks
  def connection_to_server_possible(host, port) 
    # There is no MOCK for socket connections
    if Rails.env == "test"
      return true
    end
    require 'socket' 
    require 'timeout' 
    begin 
      Timeout::timeout(2) do 
        begin 
          s = TCPSocket.new(host, port) 
          s.close 
          return true 
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH 
          return false 
        end 
      end 
    rescue Timeout::Error 
    end 
    return false 
  end 
end