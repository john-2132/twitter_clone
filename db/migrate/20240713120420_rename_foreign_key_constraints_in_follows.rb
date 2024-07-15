# frozen_string_literal: true

class RenameForeignKeyConstraintsInFollows < ActiveRecord::Migration[7.0]
  def up
    remove_foreign_key :follows, name: 'follower_user_id'
    remove_foreign_key :follows, name: 'follow_user_id'

    add_foreign_key :follows, :users, column: 'followed_id', name: 'followed_id'
    add_foreign_key :follows, :users, column: 'follower_id', name: 'follower_id'
  end

  def down
    remove_foreign_key :follows, name: 'followed_id'
    remove_foreign_key :follows, name: 'follower_id'

    add_foreign_key :follows, :users, column: 'followed_id', name: 'follower_user_id'
    add_foreign_key :follows, :users, column: 'follower_id', name: 'follow_user_id'
  end
end
