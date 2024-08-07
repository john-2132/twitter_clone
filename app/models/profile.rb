# frozen_string_literal: true

class Profile < ApplicationRecord
  has_one_attached :avatar
  has_one_attached :header
  belongs_to :user

  VALID_PHONE_NUMBER_REGEX = /\A0(
    \d{1}[-(]?\d{4}|
    \d{2}[-(]?\d{3}|
    \d{3}[-(]?\d{2}|
    \d{4}[-(]?\d{1}
  )[-)]?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/

  with_options unless: -> { validation_context == :omniauth } do
    validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  end
end
