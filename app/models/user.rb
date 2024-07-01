# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  has_many :following_relationships, class_name: 'Relationship', foreign_key: 'follower_id', dependent: :destroy, inverse_of: :follower
  has_many :followees, through: :following_relationships

  has_many :follower_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy, inverse_of: :followee
  has_many :followers, through: :follower_relationships

  validates :full_name, :username, presence: true
  validates :email, presence: true, email: true, uniqueness: true
end
