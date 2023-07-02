class AddConfirmationTokenCreatedAtToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confirmation_token_created_at, :datetime
  end
end
