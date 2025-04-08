require_relative '../spec_helper'
require_relative '../../lib/services/message_responder'

class FakeResponderTranslator
  def translate(text, from:, to:)
    "EN_#{text}"
  end
end

RSpec.describe MessageResponder do
  let(:translator) { FakeResponderTranslator.new }
  let(:service) { MessageResponder.new(translator: translator) }

  before do
    @conversation = Conversation.create!(external_id: "C123")
  end

  it "creates a new message translated to English" do
    message = service.process("Olá mundo")

    expect(message.original_text).to eq("Olá mundo")
    expect(message.translated_text).to eq("EN_Olá mundo")
    expect(message.status).to eq("confirmed")
    expect(message.conversation).to eq(@conversation)
  end
end
