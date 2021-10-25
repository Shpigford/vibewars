class AddCurrentSaleToAssets < ActiveRecord::Migration[7.0]
  def change
    add_column :assets, :current_sale_price, :string
    add_column :assets, :current_sale_token, :string
    add_column :assets, :current_sale_token_decimals, :integer
  end
end
