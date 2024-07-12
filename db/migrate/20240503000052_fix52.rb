class Fix52 < ActiveRecord::Migration[6.0]
  def up
    add_foreign_key :profiles, :users, column: :user_id
    add_foreign_key :auth_infos, :users, column: :user_id
  end
end
