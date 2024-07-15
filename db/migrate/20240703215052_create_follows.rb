# frozen_string_literal: true

class CreateFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :follows, id: false, primary_key: %i[follow_user follower_user] do |t|
      t.references :follow_user, null: false, foreign_key: { to_table: :users, name: 'follow_user_id' }
      t.references :follower_user, null: false, foreign_key: { to_table: :users, name: 'follower_user_id' }
      t.timestamps
    end
  end
end
