class CreateHenkanRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :henkan_records, force: true do |t|
      t.belongs_to :user,           null: false,                    comment: "対局者"
      t.belongs_to :recordable,     null: false, polymorphic: true, comment: "対象レコード"
      t.text :generator_params,     null: false,                    comment: "変換パラメータ"
      t.datetime :process_begin_at, null: true,                     comment: "処理開始日時"
      t.datetime :process_end_at,   null: true,                     comment: "処理終了日時"
      t.timestamps                  null: false
    end
  end
end
