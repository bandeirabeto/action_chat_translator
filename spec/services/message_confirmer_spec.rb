require_relative '../spec_helper'
require_relative '../../lib/services/message_confirmer'

class FakeSlackSender
  def post_message(channel:, text:)
    true
  end
end

RSpec.describe MessageConfirmer do
  let(:service) { MessageConfirmer.new(slack_sender: FakeSlackSender.new) }
  let(:confirmer) { MessageConfirmer.new(slack_sender: FakeSlackSender.new) }

  before do
    @conversation = Conversation.create!(external_id: "C123")
  end

  it "confirms and updates message status to 'sent'" do
    conv = Conversation.create!(external_id: "C124")
    msg = conv.messages.create!(
      original_text: "Olá",
      translated_text: "Hello",
      status: :confirmed
    )

    result = confirmer.confirm_last!
    expect(result.status).to eq("sent")
  end

  it "raises error if no conversation" do
    Conversation.delete_all
    expect { service.confirm_last! }.to raise_error("No active conversation")
  end

  it "raises error if no message to confirm" do
    expect { service.confirm_last! }.to raise_error("No message to confirm")
  end
end
