class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :asset, null: false, foreign_key: true
      t.integer :count

      t.timestamps
    end
  end
end
