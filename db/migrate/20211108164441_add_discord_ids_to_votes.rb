class AddDiscordIdsToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :discord_server_id, :bigint
    add_index :votes, :discord_server_id

    add_column :votes, :discord_user_id, :bigint
    add_index :votes, :discord_user_id
  end
end
