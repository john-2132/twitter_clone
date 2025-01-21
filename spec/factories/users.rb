# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "alice#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    confirmed_at { Time.zone.today }
    uid { SecureRandom.uuid }

    transient do
      profile_name { 'Alice' }
      profile_birth_date { { year: '2000', month: '01', day: '01' } }
      profile_phone_number { '090-1234-5678' }
    end

    profile_attributes do
      {
        name: profile_name,
        'birth_date(1i)' => profile_birth_date[:year], # birth_dateの年
        'birth_date(2i)' => profile_birth_date[:month], # birth_dateの月
        'birth_date(3i)' => profile_birth_date[:day], # birth_dateの日
        phone_number: profile_phone_number
      }
    end

    trait :without_name do
      profile_name { '' }
    end

    trait :without_email do
      email { '' }
    end

    trait :without_phone_number do
      profile_phone_number { '' }
    end

    trait :invalid_phone_number do
      profile_phone_number { '000-0000-0000' }
    end

    trait :without_password do
      password { '' }
    end

    trait :without_password_confirmation do
      password_confirmation { '' }
    end

    trait :mismatch_password do
      password_confirmation { 'wrongpassword' }
    end
  end
end
