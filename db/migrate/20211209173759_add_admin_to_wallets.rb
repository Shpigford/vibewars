class AddAdminToWallets < ActiveRecord::Migration[7.0]
  def change
    add_column :wallets, :admin, :boolean, default: false
  end
end
