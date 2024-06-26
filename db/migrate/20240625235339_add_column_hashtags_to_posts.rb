class AddColumnHashtagsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :hashtags, :jsonb
  end
end
