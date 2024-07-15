# frozen_string_literal: true

class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.string :text, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
    add_check_constraint :tweets, "(
      char_length(
        regexp_replace(text, '[\\u0000-\\u007F]', '', 'g')
      ) * 2 +
      char_length(
        regexp_replace(text, '[^\\u0000-\\u007F]', '', 'g')
      )
    ) <= 280", name: 'text_length_check'
  end
end
