class AddIndexSomeTables < ActiveRecord::Migration[6.0]
  def up
    add_index(:app_logs, :created_at)
    add_index(:swars_battles, :created_at)
  end
end
