class UnusedTableDrop < ActiveRecord::Migration[6.0]
  def change
    drop_table :colosseum_battles
    drop_table :colosseum_chat_messages
    drop_table :colosseum_chronicles
    drop_table :colosseum_lobby_messages
    drop_table :colosseum_memberships
    drop_table :colosseum_rules
    drop_table :colosseum_watch_ships
  end
end
