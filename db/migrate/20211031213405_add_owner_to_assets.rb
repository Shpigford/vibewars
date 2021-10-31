class AddOwnerToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :owner_address, :string
  end
end
