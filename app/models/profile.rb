# frozen_string_literal: true

class Profile < ApplicationRecord
  has_one_attached :avatar
  has_one_attached :header
  belongs_to :user
  validates :name, presence: true
  validate :custom_length_validation

  VALID_PHONE_NUMBER_REGEX = /\A0(
    \d{1}[-(]?\d{4}|
    \d{2}[-(]?\d{3}|
    \d{3}[-(]?\d{2}|
    \d{4}[-(]?\d{1}
  )[-)]?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/

  with_options unless: -> { validation_context == :omniauth } do
    validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
  end

  def custom_length_validation
    return if self_introduction.blank?

    max_length = calculate_max_length(self_introduction)

    return unless self_introduction.length > max_length

    errors.add(:self_introduction, "is too long (maximum is #{max_length} characters)")
  end

  private

  def calculate_max_length(text)
    half_width_count = text.count(' -~｡-ﾟ')
    full_width_count = text.length - half_width_count

    if half_width_count == text.length
      320
    elsif full_width_count == text.length
      160
    else
      (320 * half_width_count + 160 * full_width_count) / text.length
    end
  end
end
