# frozen_string_literal: true

class User < ApplicationRecord
  validates :full_name, :username, presence: true
  validates :email, presence: true, email: true, uniqueness: true
end
