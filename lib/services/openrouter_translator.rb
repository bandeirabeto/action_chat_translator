require 'net/http'
require 'uri'
require 'json'
require_relative 'translator_interface'

class OpenRouterTranslator
  include TranslatorInterface

  def initialize(api_key: ENV['OPENROUTER_API_KEY'], model: 'mistralai/mistral-7b-instruct')
    raise "Missing OpenRouter API key" if api_key.nil? || api_key.empty?

    @api_key = api_key
    @model = model
    @uri = URI('https://openrouter.ai/api/v1/chat/completions')
  end

  def translate(text, from:, to:)
    request = Net::HTTP::Post.new(@uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = {
      model: @model,
      messages: [
        { role: "system", content: "You are a professional translator. Translate all incoming messages from #{from} to #{to} only. Do not explain." },
        { role: "user", content: text }
      ]
    }.to_json

    response = Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      raise "OpenRouter error #{response.code}: #{response.body}"
    end

    json = JSON.parse(response.body)
    json.dig("choices", 0, "message", "content").strip
  end
end
