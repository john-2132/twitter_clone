# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  VALID_PHONE_NUMBER_REGEX = /\A0(
    \d{1}[-(]?\d{4}|
    \d{2}[-(]?\d{3}|
    \d{3}[-(]?\d{2}|
    \d{4}[-(]?\d{1}
  )[-)]?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/

  validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
end
