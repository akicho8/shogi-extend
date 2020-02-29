class CreateAlertLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :alert_logs, force: true do |t|
      t.string :subject, null: false
      t.string :body, limit: 8192, null: false
      t.datetime :created_at, null: false
    end
  end
end
