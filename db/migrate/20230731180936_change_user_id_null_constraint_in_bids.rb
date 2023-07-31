# frozen_string_literal: true

class ChangeUserIdNullConstraintInBids < ActiveRecord::Migration[6.1]
  def change
    change_column_null :bids, :user_id, true
  end
end
