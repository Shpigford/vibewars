class AddIndexToOwnerAddress < ActiveRecord::Migration[7.0]
  def change
    add_index :assets, :owner_address
  end
end
