class AddWalletToVotes < ActiveRecord::Migration[7.0]
  def change
    add_reference :votes, :wallet, foreign_key: true
  end
end
