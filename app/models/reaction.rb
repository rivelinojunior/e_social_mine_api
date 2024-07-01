# frozen_string_literal: true

class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  enum kind: { like: 'like', celebrate: 'celebrate', support: 'support', love: 'love', insightful: 'insightful', funny: 'funny' }

  validates :kind, presence: true
end
