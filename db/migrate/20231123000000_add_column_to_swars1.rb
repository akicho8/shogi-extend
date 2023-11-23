class AddColumnToSwars1 < ActiveRecord::Migration[5.1]
  def up
    change_table :swars_users do |t|
      t.datetime :ban_at, null: true, index: true, comment: "垢BAN日時"
    end
  end
end

