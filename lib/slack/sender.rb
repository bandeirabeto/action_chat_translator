require 'net/http'
require 'json'
require 'uri'

module Slack
  class Sender
    SLACK_API_URL = "https://slack.com/api/chat.postMessage"

    def initialize(token: ENV["SLACK_BOT_TOKEN"])
      @token = token
    end

    def post_message(channel:, text:)
      uri = URI(SLACK_API_URL)

      req = Net::HTTP::Post.new(uri)
      req["Authorization"] = "Bearer #{@token}"
      req["Content-Type"] = "application/json"
      req.body = { channel: channel, text: text }.to_json

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      body = JSON.parse(res.body)
      unless body["ok"]
        raise "Slack API error: #{body["error"]}"
      end

      true
    end
  end
end
