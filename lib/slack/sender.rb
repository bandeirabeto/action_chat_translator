require 'net/http'
require 'json'
require 'uri'

module Slack
  class Sender
    SLACK_API_URL = "https://slack.com/api/chat.postMessage"

    def initialize(token: ENV["SLACK_BOT_TOKEN"])
      @token = token

      raise "Missing Slack Bot Token" if @token.nil? || @token.empty?
    end

    def post_message(channel:, text:)
      request = build_request(channel: channel, text: text)
      response = send_request(request)
      validate_response!(response)

      true
    end

    private

    def build_request(channel:, text:)
      uri = URI(SLACK_API_URL)
      req = Net::HTTP::Post.new(uri)
      req["Authorization"] = "Bearer #{@token}"
      req["Content-Type"] = "application/json"
      req.body = { channel: channel, text: text }.to_json

      req
    end

    def send_request(req)
      uri = URI(SLACK_API_URL)

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end
    end

    def validate_response!(res)
      body = JSON.parse(res.body)

      raise "Slack API error: #{body["error"]}" unless body["ok"]
    end
  end
end
