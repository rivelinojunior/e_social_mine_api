# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :full_name, :username, presence: true
  validates :email, presence: true, email: true, uniqueness: true
end
