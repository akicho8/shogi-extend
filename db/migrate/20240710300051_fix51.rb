class Fix51 < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      t.remove :user_agent
    end
    change_table :profiles do |t|
      t.remove :twitter_key
      t.remove :description
    end
  end
end
