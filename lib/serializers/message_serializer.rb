class MessageSerializer
  def initialize(message)
    @message = message
  end

  def as_json
    {
      id: @message.id,
      original: @message.original_text,
      translated: @message.translated_text,
      status: @message.status,
      created_at: @message.created_at.iso8601
    }
  end
end
