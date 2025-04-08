require_relative 'base_record'

class Conversation < BaseRecord
  has_many :messages, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
end
