class CreateChatInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :chat_infos do |t|
      t.belongs_to :user, foreign_key: true
      t.integer :partner_id
      t.boolean :active
      t.boolean :open

      t.timestamps
    end
  end
end
