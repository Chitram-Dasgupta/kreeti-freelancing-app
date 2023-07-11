# frozen_string_literal: true

class RemoveBidNameFromBids < ActiveRecord::Migration[6.1]
  def change
    remove_column :bids, :bid_name, :string
  end
end
