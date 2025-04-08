require_relative '../spec_helper'
require_relative '../../lib/serializers/message_serializer'

RSpec.describe MessageSerializer do
  let(:conversation) { Conversation.create!(external_id: "C1") }

  it "serializes a message to a hash" do
    message = conversation.messages.create!(
      original_text: "Hi",
      translated_text: "Oi",
      status: "sent"
    )

    result = MessageSerializer.new(message).as_json

    expect(result[:id]).to eq(message.id)
    expect(result[:original]).to eq("Hi")
    expect(result[:translated]).to eq("Oi")
    expect(result[:status]).to eq("sent")
    expect(result[:created_at]).to be_a(String)
  end
end
