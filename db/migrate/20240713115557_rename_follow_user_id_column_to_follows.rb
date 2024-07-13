# frozen_string_literal: true

class RenameFollowUserIdColumnToFollows < ActiveRecord::Migration[7.0]
  def change
    rename_column :follows, :follow_user_id, :follower_id
  end
end
