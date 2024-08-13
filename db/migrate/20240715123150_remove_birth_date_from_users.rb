# frozen_string_literal: true

class RemoveBirthDateFromUsers < ActiveRecord::Migration[7.0]
  def up
    remove_column :users, :birth_date, :date
  end

  def down
    add_column :users, :birth_date, :date, default: '1930-01-01', null: false
  end
end
