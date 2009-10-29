#!/usr/bin/env ruby
#
# Display de status of a given issue
#
require File.join(File.dirname(__FILE__), '../lib/redmine-ticket/client')

params = {
            :api_key => 'API KEY', 
            :issue_id => 10
          }

RedmineTicketClient.configure do |config|
    config.params = params
    config.host = 'redmine.local'                            # the hostname your Redmine runs at
    config.port = 80                                          # the port your Redmine runs at
    config.secure = false                                           # sends data to your server via SSL (optional.)
end

pp RedmineTicketClient.issue_status
