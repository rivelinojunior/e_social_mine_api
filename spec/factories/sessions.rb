# frozen_string_literal: true

FactoryBot.define do
  factory :session do
    user
    token { SecureRandom.alphanumeric(32) }
    refresh_token { SecureRandom.alphanumeric(32) }
    expires_in { 1.hour.from_now }
    refresh_expires_in { 1.week.from_now }
    refreshed_at { nil }
  end
end
