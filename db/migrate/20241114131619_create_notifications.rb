# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :from_user, null: false, foreign_key: { to_table: :users, name: 'from_user_id' }
      t.references :to_user, null: false, foreign_key: { to_table: :users, name: 'to_user_id' }
      t.integer :action, null: false
      t.boolean :checked, null: false, default: false
      t.references :tweet, foreign_key: { to_table: :tweets, name: 'tweet_id' }
      t.references :reply, foreign_key: { to_table: :tweets, column: :parent_id, name: 'reply_id' }

      t.timestamps
    end
  end
end
