require 'net/http'
require 'net/https'
require 'rubygems'
require 'rest_client'
require 'pp'

module RedmineTicketClient

  VERSION = '0.2.3'

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
        :request       => {},
        :session       => {},
        :environment   => ENV.to_hash
      }
    end

    def default_request_params
      {}.merge RedmineTicketClient.params
    end
    
    def new_issue
      post_ticket
    end

    def post_ticket
      RestClient.post("#{protocol}://#{host}:#{port}/ticket_server/new_issue", default_request_params)
    end

    def issue_status
      RestClient.post("#{protocol}://#{host}:#{port}/ticket_server/issue_status", :api_key => default_request_params[:api_key], :issue_id => default_request_params[:issue_id])
    end
    def issues
      RestClient.post("#{protocol}://#{host}:#{port}/ticket_server/issues", :api_key => default_request_params[:api_key], :issue_id => default_request_params[:issue_id])
    end
    def projects 
      RestClient.post("#{protocol}://#{host}:#{port}/ticket_server/projects", :api_key => default_request_params[:api_key], :issue_id => default_request_params[:issue_id])
    end
    def journals 
      RestClient.post("#{protocol}://#{host}:#{port}/ticket_server/journals", :api_key => default_request_params[:api_key], :issue_id => default_request_params[:issue_id])
    end
  end

end
