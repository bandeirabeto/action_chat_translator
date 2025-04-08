require_relative '../models/conversation'
require_relative '../models/message'
require_relative 'openrouter_translator'

class MessageResponder
  def initialize(translator: OpenRouterTranslator.new)
    @translator = translator
  end

  def process(user_text_pt)
    conversation = Conversation.order(created_at: :desc).first
    raise "No active conversation" unless conversation

    translated = @translator.translate(user_text_pt, from: "pt-br", to: "en")

    conversation.messages.create!(
      original_text: user_text_pt,
      translated_text: translated,
      status: :confirmed
    )
  end
end
