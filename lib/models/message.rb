require_relative 'base_record'

class Message < BaseRecord
  belongs_to :conversation

  enum status: {
    received: 0,
    translated: 1,
    confirmed: 2,
    sent: 3,
    failed: 4
  }

  validates :original_text, presence: true
  validates :translated_text, presence: true
  validates :status, presence: true
end
