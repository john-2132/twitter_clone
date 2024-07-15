# frozen_string_literal: true

class RenameFollowerUserIdColumnToFollows < ActiveRecord::Migration[7.0]
  def change
    rename_column :follows, :follower_user_id, :followed_id
  end
end
