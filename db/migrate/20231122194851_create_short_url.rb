class CreateShortUrl < ActiveRecord::Migration[5.1]
  def up
    create_table :short_url_components, force: true do |t|
      t.string :key,                null: false, index: { unique: true }
      t.string :original_url,       null: false, index: { unique: true }
      t.integer :access_logs_count, null: false, default: 0, comment: "総アクセス数"
      t.timestamps                  null: false
    end

    create_table :short_url_access_logs, force: true do |t|
      t.belongs_to :component, null: true,  comment: "コンポーネント"
      t.datetime :created_at,  null: false, comment: "記録日時"
    end
  end
end
