class AddHasAwardedBidToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :has_awarded_bid, :boolean, default: false
  end
end
