# frozen_string_literal: true

class User < ApplicationRecord
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable, :omniauthable, omniauth_providers: %i[github]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  VALID_PHONE_NUMBER_REGEX = /\A0(
    \d{1}[-(]?\d{4}|
    \d{2}[-(]?\d{3}|
    \d{3}[-(]?\d{2}|
    \d{4}[-(]?\d{1}
  )[-)]?\d{4}\z|\A0[5789]0-?\d{4}-?\d{4}\z/

  with_options unless: -> { validation_context == :omniauth } do
    validates :phone_number, presence: true, format: { with: VALID_PHONE_NUMBER_REGEX }
    validates :uid, uniqueness: { scope: :provider }
  end
end
