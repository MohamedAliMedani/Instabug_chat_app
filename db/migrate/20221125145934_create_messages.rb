class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_number, null: false
      t.references :chat, foreign_key: true
      t.text :body, null: false
      t.boolean :is_deleted, null: false, default: false

      t.timestamps

      t.index [:message_number, :chat_id], unique: true
    end
  end
end
