# frozen_string_literal: true

module Postdoc
  # Spins up a Chrome process.
  class ChromeProcess
    attr_reader :pid, :port

    def initialize(port: Random.rand(1025..65535), **_options)
      @port = port
      @pid = Process.spawn "chrome --remote-debugging-port=#{port} --headless",
          out: File::NULL, err: File::NULL
    end

    def alive?
      @alive ||= test_socket!
    rescue Errno::ECONNREFUSED
      false
    end

    def kill
      Process.kill 'INT', pid
      Process.wait pid
    rescue
      true
    end

    def client
      Client.new port
    end

    private

    def test_socket!
      TCPSocket.new('localhost', port)
    end
  end
end
