require_relative "recipient"
require "httparty"
require 'pry'

module Slack
  class Channel < Recipient
    attr_reader :topic, :member_count
    
    def initialize(slack_id, name, topic = nil, member_count)
      super(slack_id, name)
      @topic = topic
      @member_count = member_count
    end
    
    def details
      tp self, "slack_id", "name", "topic", "member_count"
    end
    
    def self.list
      response = Channel.get("https://slack.com/api/conversations.list")
      channels = []
      
      response["channels"].each do |channel|
        channels << Channel.new(
          slack_id = channel["id"],
          name = channel["name"],
          topic = channel["topic"]["value"],
          member_count = channel["num_members"],
        )
      end
      return channels
    end 
  end
end
