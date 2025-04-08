module TranslatorInterface
  def translate(text, from:, to:)
    raise NotImplementedError, "#{self.class} must implement the translate method"
  end
end
