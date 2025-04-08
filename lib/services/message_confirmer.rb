require_relative '../models/conversation'
require_relative '../models/message'
require_relative '../slack/sender'

class MessageConfirmer
  def initialize(slack_sender: Slack::Sender.new)
    @slack_sender = slack_sender
  end

  def confirm_last!
    conversation = Conversation.order(created_at: :desc).first
    raise "No active conversation" unless conversation

    message = conversation.messages.confirmed.order(created_at: :desc).first
    raise "No message to confirm" unless message

    @slack_sender.post_message(
      channel: conversation.external_id,
      text: message.translated_text
    )

    message.update!(status: :sent)
    message
  end
end
