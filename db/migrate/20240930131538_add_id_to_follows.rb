# frozen_string_literal: true

class AddIdToFollows < ActiveRecord::Migration[7.0]
  def change
    add_column :follows, :id, :primary_key
  end
end
