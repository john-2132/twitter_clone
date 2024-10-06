# frozen_string_literal: true

class AddIndexToFollowsOnFollowerIdAndFollowedId < ActiveRecord::Migration[7.0]
  def change
    add_index :follows, %i[follower_id followed_id], unique: true
  end
end
