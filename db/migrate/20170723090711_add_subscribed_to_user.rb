class AddSubscribedToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :subscribed, :boolean
  end
end
