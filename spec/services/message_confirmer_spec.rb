require_relative '../spec_helper'
require_relative '../../lib/services/message_confirmer'

RSpec.describe MessageConfirmer do
  let(:service) { MessageConfirmer.new }

  before do
    @conversation = Conversation.create!(external_id: "C123")
  end

  it "confirms and updates message status to 'sent'" do
    msg = @conversation.messages.create!(
      original_text: "Olá",
      translated_text: "Hello",
      status: "confirmed"
    )

    confirmed = service.confirm_last!

    expect(confirmed.status).to eq("sent")
    expect(confirmed.id).to eq(msg.id)
  end

  it "raises error if no conversation" do
    Conversation.delete_all
    expect { service.confirm_last! }.to raise_error("No active conversation")
  end

  it "raises error if no message to confirm" do
    expect { service.confirm_last! }.to raise_error("No message to confirm")
  end
end
