require_relative '../spec_helper'

RSpec.describe Conversation, type: :model do
  before do
    Conversation.destroy_all
  end

  it "is valid with a unique external_id" do
    convo = Conversation.new(external_id: "C12345")
    expect(convo).to be_valid
  end

  it "is invalid without external_id" do
    convo = Conversation.new
    expect(convo).not_to be_valid
    expect(convo.errors[:external_id]).to include("can't be blank")
  end

  it "is invalid with duplicate external_id" do
    Conversation.create!(external_id: "C12345")
    convo = Conversation.new(external_id: "C12345")
    expect(convo).not_to be_valid
    expect(convo.errors[:external_id]).to include("has already been taken")
  end

  it "can have many messages" do
    convo = Conversation.create!(external_id: "C1")
    message1 = convo.messages.create!(original_text: "Hello", translated_text: "Olá", status: "received")
    message2 = convo.messages.create!(original_text: "How are you?", translated_text: "Como vai?", status: "received")

    expect(convo.messages).to include(message1, message2)
  end
end
