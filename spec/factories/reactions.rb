# frozen_string_literal: true

FactoryBot.define do
  factory :reaction do
    user
    post
    kind { Reaction.kinds.keys.sample }
  end
end
