# frozen_string_literal: true

class AddIndexToFavoritesOnTweetIdAndUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :favorites, %i[tweet_id user_id], unique: true
  end
end
