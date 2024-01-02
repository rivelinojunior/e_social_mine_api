# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :username
      t.string :password_digest

      t.timestamps

      t.index :email, unique: true
    end
  end
end
