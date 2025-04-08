require_relative '../models/conversation'
require_relative '../models/message'

class MessageProcessor
  def initialize(translator:)
    @translator = translator
  end

  # Processes a message received in Slack
  #
  # Parameters:
  # - external_conversation_id: Slack channel ID
  # - original_text: Original text of the message (in English)
  #
  # Return: Message stored with status `translated`
  def process_incoming(external_conversation_id:, original_text:)
    conversation = Conversation.find_or_create_by!(external_id: external_conversation_id)

    translated = @translator.translate(original_text, from: "en", to: "pt-br")

    conversation.messages.create!(
      original_text: original_text,
      translated_text: translated,
      status: :translated
    )
  end
end
