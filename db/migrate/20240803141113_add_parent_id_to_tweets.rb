# frozen_string_literal: true

class AddParentIdToTweets < ActiveRecord::Migration[7.0]
  def up
    add_column :tweets, :parent_id, :bigint
    add_index :tweets, :parent_id
    add_foreign_key :tweets, :tweets, column: :parent_id
  end

  def down
    remove_foreign_key :tweets, column: :parent_id
    remove_index :tweets, :parent_id
    remove_column :tweets, :parent_id
  end
end
