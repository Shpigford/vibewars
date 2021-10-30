class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.string :address
      t.string :ens

      t.timestamps
    end
  end
end
