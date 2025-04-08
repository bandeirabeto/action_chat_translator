require 'json'
require_relative '../../models/conversation'
require_relative '../../services/message_responder'
require_relative '../../services/message_confirmer'
require_relative '../../serializers/message_serializer'

class MessagesController
  def call(env)
    req = Rack::Request.new(env)

    case [req.request_method, req.path_info]
    when ['GET', '']
      list_messages
    when ['POST', '']
      create_response(req)
    when ['POST', '/confirm']
      confirm_last
    else
      respond(404, { error: "Not found" })
    end
  end

  private

  def list_messages
    conversation = Conversation.order(created_at: :desc).first
    return respond(200, []) unless conversation

    messages = conversation.messages.order(:created_at)
    json = messages.map { |m| MessageSerializer.new(m).as_json }
    respond(200, json)
  end

  def create_response(req)
    data = JSON.parse(req.body.read)
    text = data['text']
    return respond(400, { error: "Missing text" }) if text.to_s.strip.empty?

    responder = MessageResponder.new
    message = responder.process(text)

    respond(201, MessageSerializer.new(message).as_json)
  end

  def confirm_last
    confirmer = MessageConfirmer.new
    message = confirmer.confirm_last!

    respond(200, MessageSerializer.new(message).as_json)
  rescue StandardError => e
    respond(404, { error: e.message })
  end

  def respond(status, body)
    [status, { 'Content-Type' => 'application/json' }, [body.to_json]]
  end
end
