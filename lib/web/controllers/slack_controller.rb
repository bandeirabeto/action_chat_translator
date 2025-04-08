require 'json'
require_relative '../../services/message_processor'

class SlackController
  def call(env)
    req = Rack::Request.new(env)

    case req.request_method
    when "POST"
      handle_event(req)
    else
      [404, { 'Content-Type' => 'application/json' }, ['{"error":"not found"}']]
    end
  end

  private

  def handle_event(req)
    data = JSON.parse(req.body.read)

    # First Slack handshake (challenge)
    if data["type"] == "url_verification"
      return [200, { 'Content-Type' => 'text/plain' }, [data["challenge"]]]
    end

    if data["type"] == "event_callback" && data["event"]["type"] == "message"
      channel = data["event"]["channel"]
      text = data["event"]["text"]
      user = data["event"]["user"]

      # Ignore blank messages or bot message
      return [200, {}, []] if text.nil? || user.nil?

      processor = MessageProcessor.new(translator: OpenRouterTranslator.new)
      processor.process_incoming(external_conversation_id: channel, original_text: text)

      return [200, {}, []]
    end

    [200, {}, []]
  end
end
