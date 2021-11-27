class CreateWkbkAccessLogs < ActiveRecord::Migration[6.0]
  def up
    change_table :wkbk_books do |t|
      t.integer :access_logs_count, default: 0, null: false, index: true, comment: "総アクセス数"
    end

    create_table :wkbk_access_logs, force: true do |t|
      t.belongs_to :user,     null: true,  comment: "参照者"
      t.belongs_to :book,     null: false, comment: "問題集"
      t.datetime :created_at, null: false, comment: "記録日時"
    end
  end

  def down
    remove_column :wkbk_books, :access_logs_count
    drop_table :wkbk_access_logs
  end
end
