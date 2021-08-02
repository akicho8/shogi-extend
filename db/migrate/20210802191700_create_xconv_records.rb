class CreateXconvRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :xconv_records, force: true do |t|
      t.belongs_to :user,           null: false,                                  comment: "対局者"
      t.belongs_to :recordable,     null: false, polymorphic: true,               comment: "対象レコード"
      t.text :convert_params,       null: false,                    index: false, comment: "変換パラメータ"
      t.datetime :process_begin_at, null: true,                     index: true,  comment: "処理開始日時"
      t.datetime :process_end_at,   null: true,                     index: true,  comment: "処理終了日時"
      t.datetime :successed_at,     null: true,                     index: true,  comment: "成功日時"
      t.datetime :errored_at,       null: true,                     index: true,  comment: "エラー日時"
      t.string :error_message,      null: true,                     index: false, comment: "エラーメッセージ"
      t.timestamps                  null: false
      t.index :created_at
    end
  end
end
