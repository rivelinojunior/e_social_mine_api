# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    user
    content { Faker::Lorem.paragraph }
    hashtags { nil }

    trait :with_hash_tags do
      hashtags { Faker::Lorem.words(number: 5) }
    end
  end
end
