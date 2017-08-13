class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.belongs_to :chat_info, foreign_key: true
      t.text :body
      t.string :status
      t.integer :user_id

      t.timestamps
    end
  end
end
