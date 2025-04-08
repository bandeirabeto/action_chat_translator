class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.string :external_id, null: false

      t.timestamps
    end

    add_index :conversations, :external_id, unique: true
  end
end
