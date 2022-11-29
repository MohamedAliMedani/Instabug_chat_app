class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications, id: :string do |t|
      t.string :name, null: false
      t.integer :chats_count, null: false, default: 0
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
      end
  end
end
