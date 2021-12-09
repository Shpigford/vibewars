class ChangeOpenSeaIdToBigInt < ActiveRecord::Migration[7.0]
  def change
    change_column :events, :opensea_id, :bigint
  end
end
