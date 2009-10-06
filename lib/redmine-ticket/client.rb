require 'net/http'
require 'net/https'
require 'rubygems'

module RedmineTicketClient

  VERSION = '0.1'

  class << self
    attr_accessor :host, :port, :secure, :params, :http_open_timeout, :http_read_timeout,
                  :proxy_host, :proxy_port, :proxy_user, :proxy_pass

    # The port on which your Redmine server runs.
    def port
      @port || (secure ? 443 : 80)
    end

    # The host to connect to.
    def host
      @host ||= 'hoptoadapp.com'
    end
    
    # The HTTP open timeout (defaults to 2 seconds).
    def http_open_timeout
      @http_open_timeout ||= 2
    end
    
    # The HTTP read timeout (defaults to 5 seconds).
    def http_read_timeout
      @http_read_timeout ||= 5
    end
    
    # NOTE: secure connections are not yet supported.
    def configure
      yield self
    end
    
    def protocol #:nodoc:
      secure ? "https" : "http"
    end
    
    def url #:nodoc:
      URI.parse("#{protocol}://#{host}:#{port}/ticket_server/")
    end
    
    def default_ticket_options #:nodoc:
      {
        :params       => RedmineTicketClient.params,
        :error_message => 'Notification',
        :request       => {},
        :session       => {},
        :environment   => ENV.to_hash
      }
    end
    
    def post_ticket
      Sender.new.post_to_redmine( default_ticket_options )
    end
  end

  class Sender
    def rescue_action_in_public(exception)
    end

    def post_to_redmine hash_or_exception
      ticket = hash_or_exception
      send_to_redmine(:ticket => ticket)
    end
    
    def send_to_redmine data #:nodoc:
      headers = {
        'Content-type' => 'application/x-yaml',
        'Accept' => 'text/xml, application/xml'
      }

      url = RedmineTicketClient.url
      
      http = Net::HTTP::Proxy(RedmineTicketClient.proxy_host, 
                              RedmineTicketClient.proxy_port, 
                              RedmineTicketClient.proxy_user, 
                              RedmineTicketClient.proxy_pass).new(url.host, url.port)

      http.use_ssl = true
        http.read_timeout = RedmineTicketClient.http_read_timeout
        http.open_timeout = RedmineTicketClient.http_open_timeout
      http.use_ssl = !!RedmineTicketClient.secure 

        response = begin
          http.post(url.path, stringify_keys(data).to_yaml, headers)
        rescue TimeoutError => e
          $stderr.puts  "Timeout while contacting the Redmine server."
          nil
        end
       
      case response
      when Net::HTTPSuccess then
        puts "Redmine Success: #{response.class}"
      else
        $stderr.puts "Redmine Failure: #{response.class}\n#{response.body if response.respond_to? :body}"
      end
    end
    
    def stringify_keys(hash) #:nodoc:
      hash.inject({}) do |h, pair|
        h[pair.first.to_s] = pair.last.is_a?(Hash) ? stringify_keys(pair.last) : pair.last
        h
      end
    end
  end
end
