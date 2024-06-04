# frozen_string_literal: true

class Session < ApplicationRecord
  belongs_to :user

  validates :token, :refresh_token, presence: true, uniqueness: true
  validates :expires_in, :refresh_expires_in, presence: true
end
