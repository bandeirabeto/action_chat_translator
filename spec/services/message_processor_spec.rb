require_relative '../spec_helper'
require_relative '../../lib/services/message_processor'

class FakeProcessorTranslator
  def translate(text, from:, to:)
    "FAKE_#{text}_#{from}_TO_#{to}"
  end
end

RSpec.describe MessageProcessor do
  let(:translator) { FakeProcessorTranslator.new }
  let(:processor) { MessageProcessor.new(translator: translator) }

  it "creates a conversation if it doesn't exist" do
    expect {
      processor.process_incoming(external_conversation_id: "C123", original_text: "Hello")
    }.to change(Conversation, :count).by(1)
  end

  it "reuses an existing conversation" do
    Conversation.create!(external_id: "C123")
    expect {
      processor.process_incoming(external_conversation_id: "C123", original_text: "Hi again")
    }.not_to change(Conversation, :count)
  end

  it "creates a message with translated text" do
    processor.process_incoming(external_conversation_id: "C1", original_text: "Hello!")

    msg = Message.last
    expect(msg.original_text).to eq("Hello!")
    expect(msg.translated_text).to eq("FAKE_Hello!_en_TO_pt-br")
    expect(msg.translated?).to be true
  end
end
