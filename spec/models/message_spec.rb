require_relative '../spec_helper'

RSpec.describe Message, type: :model do
  let(:conversation) { Conversation.create!(external_id: "C2") }

  it "is valid with all attributes" do
    msg = Message.new(
      conversation: conversation,
      original_text: "Hi",
      translated_text: "Oi",
      status: "received"
    )
    expect(msg).to be_valid
  end

  it "is invalid without original_text" do
    msg = Message.new(
      conversation: conversation,
      translated_text: "Oi",
      status: "received"
    )
    expect(msg).not_to be_valid
    expect(msg.errors[:original_text]).to include("can't be blank")
  end

  it "is invalid without translated_text" do
    msg = Message.new(
      conversation: conversation,
      original_text: "Hi",
      status: "received"
    )
    expect(msg).not_to be_valid
    expect(msg.errors[:translated_text]).to include("can't be blank")
  end

  it "is invalid without status" do
    msg = Message.new(
      conversation: conversation,
      original_text: "Hi",
      translated_text: "Oi",
      status: nil
    )
    expect(msg).not_to be_valid
    expect(msg.errors[:status]).to include("can't be blank")
  end

  it "belongs to a conversation" do
    msg = conversation.messages.create!(
      original_text: "Hello",
      translated_text: "Olá",
      status: "received"
    )
    expect(msg.conversation).to eq(conversation)
  end

  it "has valid status enums" do
    msg = Message.create!(
      conversation: conversation,
      original_text: "Hi",
      translated_text: "Oi",
      status: "translated"
    )
    expect(msg.translated?).to be true
  end
end
