# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    post
    user
    message { Faker::Lorem.sentence }
  end
end
