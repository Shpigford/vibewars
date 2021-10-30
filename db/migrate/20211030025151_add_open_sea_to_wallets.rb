class AddOpenSeaToWallets < ActiveRecord::Migration[7.0]
  def change
    add_column :wallets, :opensea_username, :string
    add_column :wallets, :opensea_profile_img_url, :string
  end
end
