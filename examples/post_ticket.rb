require File.join(File.dirname(__FILE__), '../lib/redmine-ticket/client')
params = {
                  # the identifier you specified for your project
                  :project => 'test', 
                  # the name of your Tracker of choice in Redmine
                  :tracker => 'Bug',
                  # the key you generated before in Redmine
                  :api_key => 'API_KEY_HERE', 
                  # the name of a ticket category (optional.)
                  :category => 'Development', 

                  # the login of a user the ticket should get assigned to by default
                  #:assigned_to => 'admin', #optional

                  # the default priority (use a number, not a name. optional.)
                  #:priority => 5,

                  :subject => 'malabaristic',
                  :description => 'description text'

                 }.to_yaml

RedmineTicketClient.configure do |config|
    config.params = params
    config.host = '127.0.0.1'                            # the hostname your Redmine runs at
    config.port = 3000                                           # the port your Redmine runs at
    config.secure = false                                           # sends data to your server via SSL (optional.)
  end

RedmineTicketClient.post_ticket
