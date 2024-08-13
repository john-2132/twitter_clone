# frozen_string_literal: true

class RemoveNameFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :name, :string
  end

  def down
    add_column :users, :name, :string, default: '', null: false
  end
end
