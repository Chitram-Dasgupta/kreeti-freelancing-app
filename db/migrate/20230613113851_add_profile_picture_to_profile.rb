class AddProfilePictureToProfile < ActiveRecord::Migration[6.1]
  def change
    add_column :profiles, :profile_picture, :string
  end
end
