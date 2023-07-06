class AddEmailConfirmedToUsers < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.boolean :email_confirmed, default: false, null: false
      t.string :confirmation_token
    end
  end
end
