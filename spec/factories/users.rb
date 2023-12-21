# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    full_name { Faker::Name.name }
    username { Faker::Internet.username }
    password { Faker::Internet.password }
  end
end
