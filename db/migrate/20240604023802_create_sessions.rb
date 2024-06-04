# frozen_string_literal: true

class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token, null: false
      t.string :refresh_token, null: false
      t.datetime :expires_in, null: false
      t.datetime :refresh_expires_in, null: false
      t.datetime :refreshed_at

      t.timestamps

      t.index :token, unique: true
      t.index :refresh_token, unique: true
    end
  end
end
