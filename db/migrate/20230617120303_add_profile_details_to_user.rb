class AddProfileDetailsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :qualification, :string
    add_column :users, :experience, :integer
    add_column :users, :industry, :string
    add_column :users, :profile_picture, :string
  end
end
