# frozen_string_literal: true

class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :id, uniqueness: { scope: %i[tweet_id user_id] }
end
