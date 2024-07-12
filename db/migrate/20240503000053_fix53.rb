class Fix53 < ActiveRecord::Migration[6.0]
  def up
    drop_table :mute_infos, if_exists: true
  end
end
