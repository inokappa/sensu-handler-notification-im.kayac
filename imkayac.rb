#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-handler'
require 'timeout'
require 'im-kayac'

class ImkayacNotif < Sensu::Handler

  def event_name
    @event['client']['name'] + '/' + @event['check']['name']
  end

  def handle
    user = settings["imkayac"]["user"]
    pass = settings["imkayac"]["pass"]
    message = @event['check']['notification'] || @event['check']['output']

    begin
      timeout(3) do
        if @event['action'].eql?("resolve")
          p ImKayac.to("#{user}").password("#{pass}").post("ressolve - #{message}")
        else
          p ImKayac.to("#{user}").password("#{pass}").post("attention - #{message}")
        end
      end
    rescue Timeout::Error
      puts "im.kayac -- timed out while attempting to message"
    end
  end

end
