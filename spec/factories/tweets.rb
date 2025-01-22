# frozen_string_literal: true

FactoryBot.define do
  factory :tweet do
    text { 'テスト用ツイートです' }
    association :user

    trait :without_text do
      text { '' }
    end

    trait :with_too_long_text do
      text { 'a' * 281 }
    end
  end
end
