class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :conversation, null: false, foreign_key: true
      t.text :original_text, null: false
      t.text :translated_text, null: false
      t.integer :status, null: false, default: 0  # enum: received, translated, etc.

      t.timestamps
    end
  end
end
