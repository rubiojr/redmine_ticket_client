require File.join(File.dirname(__FILE__), '../lib/redmine-ticket/client')
params = {
                  # the identifier you specified for your project
                  :project => 'test', 
                  # the name of your Tracker of choice in Redmine
                  :tracker => 'Bug',
                  # the key you generated before in Redmine
                  :api_key => 'API KEY', 
                  # the name of a ticket category (optional.)
                  :category => 'Development', 

                  # the login of a user the ticket should get assigned to by default
                  #:assigned_to => 'admin', #optional

                  # the default priority (use a number, not a name. optional.)
                  #:priority => 5,

                  :subject => "Test RTS #{rand * 100}",
                  :description => 'description text',
                  :custom_fields => {
                    :field1 => 'bar',
                    :field2 => 'foo'
                  }

                 }.to_yaml

RedmineTicketClient.configure do |config|
    config.params = params
    config.host = 'redmine.local' 
    config.port = 80                 
    config.secure = false                
  end

RedmineTicketClient.post_ticket
