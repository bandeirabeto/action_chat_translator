require 'net/http'
require 'uri'
require 'json'
require_relative 'translator_interface'

class OpenRouterTranslator
  include TranslatorInterface

  def initialize(api_key: ENV['OPENROUTER_API_KEY'], model: 'openai/gpt-3.5-turbo')
    raise "Missing OpenRouter API key" if api_key.nil? || api_key.empty?

    @api_key = api_key
    @model = model
    @uri = URI('https://openrouter.ai/api/v1/chat/completions')
  end

  def translate(text, from:, to:)
    prompt = build_prompt(text, from, to)
    response = make_request(prompt)
    validate_response!(response)
    parse_response(response)
  end

  private

  def build_prompt(text, from, to)
    <<~PROMPT
      You are a translation engine. Translate the input from #{from} to #{to}.
      Respond ONLY with the translated sentence. Do NOT explain, comment, rephrase, or add anything else. Output the translation only.

      Input: #{text}
    PROMPT
  end

  def make_request(prompt)
    request = Net::HTTP::Post.new(@uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = {
      model: @model,
      messages: [
        { role: "system", content: prompt }
      ]
    }.to_json

    Net::HTTP.start(@uri.hostname, @uri.port, use_ssl: true) do |http|
      http.request(request)
    end
  end

  def validate_response!(response)
    return if response.is_a?(Net::HTTPSuccess)

    raise "OpenRouter error #{response.code}: #{response.body}"
  end

  def parse_response(response)
    json = JSON.parse(response.body)
    json.dig("choices", 0, "message", "content").strip
  end
end
