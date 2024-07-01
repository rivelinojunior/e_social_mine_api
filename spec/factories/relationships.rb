# frozen_string_literal: true

FactoryBot.define do
  factory :relationship do
    follower { association :user }
    followee { association :user }
  end
end
