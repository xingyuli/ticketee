class AddAssetToTickets < ActiveRecord::Migration[5.1]
  def change
    add_column :tickets, :asset, :string
  end
end
