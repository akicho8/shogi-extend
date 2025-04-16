class CreateKiwi < ActiveRecord::Migration[6.0]
  def change
    ForeignKey.disabled

    create_table :kiwi_folders, force: true do |t|
      t.string :key,                                   null: false, index: { unique: true }
      t.integer :position,                             null: false, index: true
      t.integer :bananas_count,    default: 0,           null: false, index: false,      comment: "問題集数"
      t.timestamps
    end

    create_table :kiwi_bananas, force: true do |t|
      t.string     :key,                               null: false, index: { unique: true }
      t.belongs_to :user,                              null: false,                    comment: "作成者"
      t.belongs_to :folder,                            null: false,                    comment: "フォルダ"
      t.belongs_to :lemon, index: { unique: true },    null: false,                    comment: "動画"
      t.string     :title,       limit: 100,           null: false,                    comment: "タイトル"
      t.text       :description, limit: 5000,          null: false,                    comment: "説明"
      t.float      :thumbnail_pos,                     null: false, index: false,      comment: "サムネ位置"
      t.integer :banana_messages_count,      default: 0, null: false, index: true,       comment: "コメント数"
      t.integer :access_logs_count,        default: 0, null: false, index: true,       comment: "総アクセス数"
      t.timestamps
    end

    create_table :kiwi_banana_messages, force: true do |t|
      t.belongs_to :user,                              null: false,                    comment: "発言者"
      t.belongs_to :banana,                              null: false,                    comment: "動画"
      t.string :body, limit: 512,                      null: false,                    comment: "発言"
      t.integer :position, index: true,                null: false,                    comment: "番号"
      t.datetime :deleted_at,                          null: true,                     comment: "削除日時"
      t.index [:banana_id, :position], unique: true
      t.timestamps
    end

    create_table :kiwi_access_logs, force: true do |t|
      t.belongs_to :user,                              null: true,                     comment: "参照者"
      t.belongs_to :banana,                              null: false,                    comment: "動画"
      t.datetime :created_at,                          null: false,                    comment: "記録日時"
    end

    create_table :kiwi_lemons, force: true do |t|
      t.belongs_to :user,                              null: false,                    comment: "所有者"
      t.belongs_to :recordable,                        null: false, polymorphic: true, comment: "対象レコード"
      t.text :all_params,                              null: false,                    comment: "変換パラメータ全部入り"
      t.datetime :process_begin_at,                    null: true, index: true,        comment: "処理開始日時"
      t.datetime :process_end_at,                      null: true, index: true,        comment: "処理終了日時"
      t.datetime :successed_at,                        null: true, index: true,        comment: "成功日時"
      t.datetime :errored_at,                          null: true, index: true,        comment: "エラー日時"
      t.text :error_message,                           null: true,                     comment: "エラーメッセージ"
      t.string :content_type,                          null: true,                     comment: "コンテンツタイプ"
      t.integer :file_size,                            null: true,                     comment: "ファイルサイズ"
      t.text :ffprobe_info,                            null: true,                     comment: "変換パラメータ"
      t.string :browser_path,                          null: true,                     comment: "生成したファイルへのパス"
      t.string :filename_human,                        null: true,                     comment: "ダウンロードファイル名"
      t.timestamps                                     null: false
      t.index :created_at
    end
  end
end
