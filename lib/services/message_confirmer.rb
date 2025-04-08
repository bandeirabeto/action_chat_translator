require_relative '../models/conversation'
require_relative '../models/message'

class MessageConfirmer
  def confirm_last!
    conversation = Conversation.order(created_at: :desc).first
    raise "No active conversation" unless conversation

    message = conversation.messages.confirmed.order(created_at: :desc).first
    raise "No message to confirm" unless message

    # TODO: here send to Slack

    message.update!(status: :sent)
    message
  end
end
