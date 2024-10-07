# frozen_string_literal: true

class AddIndexToRetweetsOnTweetIdAndUserId < ActiveRecord::Migration[7.0]
  def change
    add_index :retweets, %i[tweet_id user_id], unique: true
  end
end
