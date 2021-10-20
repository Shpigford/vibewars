class ChangeCountToIpAddress < ActiveRecord::Migration[7.0]
  def change
    remove_column :votes, :count
    add_column :votes, :ip_address, :string
  end
end
