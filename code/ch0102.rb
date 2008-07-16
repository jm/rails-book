class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :name, :string
      t.column :body, :text
      t.column :created_at, :string
      t.column :post_id, :integer
    end
  end

  def self.down
    drop_table :comments
  end
end