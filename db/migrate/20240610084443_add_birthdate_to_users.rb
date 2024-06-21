# frozen_string_literal: true

class AddBirthdateToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :birth_date, :date
  end

  def down
    remove_column :users, :birth_date, :date
  end
end
