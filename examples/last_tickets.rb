#!/usr/bin/env ruby
#
# Display tickets created in the last hour
#
require File.join(File.dirname(__FILE__), '../lib/redmine-ticket/client')
require 'rubygems'
require 'json'
require 'time'


params = {
            :api_key => 'APIKEY', 
            :issue_id => 646 
          }

RedmineTicketClient.configure do |config|
    config.params = params
    config.host = 'redmine.sistemas.cti.csic.es'
    config.port = 80      
    config.secure = false                           
end

JSON.parse(RedmineTicketClient.issues).each do |t|
  time = Time.parse t['updated_on']
  offset = Time.now - time
  if (offset < 3600)
    puts t['subject']
  end
end
