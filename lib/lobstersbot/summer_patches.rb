module Lobstersbot
  module SummerPatches
    def config_dir(file)
      File.join(ARGV[0], file)
    end

    def load_config
      @config = HashWithIndifferentAccess.new(YAML.load_file(config_dir('lobstersbot.yml')))
    end

    def connect!
      @connection = TCPSocket.open(server, port)

      if config[:use_ssl]
        cert_file = File.read(config_dir('client.pem'))
        context = OpenSSL::SSL::SSLContext.new
        context.key = OpenSSL::PKey.read(cert_file)
        context.crt = OpenSSL::X509::Certificate.new(cert_file)

        @connection = OpenSSL::SSL::SSLSocket.new(@connection, context).connect
      end

      response("USER #{config[:nick]} #{config[:nick]} #{config[:nick]} #{config[:nick]}")
      response("NICK #{config[:nick]}")
    end
  end
end
