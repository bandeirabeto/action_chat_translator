require_relative '../spec_helper'
require 'json'
require 'net/http'
require_relative '../../lib/services/openrouter_translator'

RSpec.describe OpenRouterTranslator do
  let(:api_key) { 'test-api-key' }
  let(:translator) { OpenRouterTranslator.new(api_key: api_key) }

  it 'translates text from English to Portuguese using OpenRouter' do
    response = instance_double(Net::HTTPResponse, body: {
      choices: [
        { message: { content: "Olá, como você está?" } }
      ]
    }.to_json, code: '200', is_a?: true)

    allow(Net::HTTP).to receive(:start).and_return(response)

    result = translator.translate("Hello, how are you?", from: "en", to: "pt")
    expect(result).to eq("Olá, como você está?")
  end

  it 'raises an error if the API returns a failure' do
    bad_response = instance_double(Net::HTTPResponse, code: '500', body: 'Internal Server Error', is_a?: false)
    allow(Net::HTTP).to receive(:start).and_return(bad_response)

    expect {
      translator.translate("This will fail", from: "en", to: "pt")
    }.to raise_error(/OpenRouter error 500/)
  end
end
