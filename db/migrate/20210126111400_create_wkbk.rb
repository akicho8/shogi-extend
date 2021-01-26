class CreateWkbk < ActiveRecord::Migration[6.0]
  def change
    DbCop.foreign_key_checks_disable do
      ################################################################################ 静的

      # フォルダ
      create_table :wkbk_folders, force: true do |t|
        t.belongs_to :user, foreign_key: true,  null: false
        t.string :type, null: false, comment: "for STI"
        t.timestamps
        t.index [:type, :user_id], unique: true
      end

      # 問題の種類
      create_table :wkbk_lineages, force: true do |t|
        t.string :key, null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      ################################################################################

      create_table :wkbk_articles, force: true do |t|
        t.string :key,                      null: false, index: true

        t.belongs_to :user,                 null: false, foreign_key: true,                            comment: "作成者"
        t.belongs_to :folder,               null: false, foreign_key: {to_table: :wkbk_folders},       comment: "フォルダ"
        t.belongs_to :lineage,              null: false, foreign_key: {to_table: :wkbk_lineages},      comment: "種類"
        t.belongs_to :book,                 null: true,  foreign_key: {to_table: :wkbk_books},         comment: "本"

        t.string :init_sfen,                null: false, index: true,                                  comment: "問題"
        t.integer :time_limit_sec,          null: true,  index: true,                                  comment: "制限時間(秒)"
        t.integer :difficulty_level,        null: true,  index: true,                                  comment: "難易度"
        t.string :title,                    null: true,  index: false,                                 comment: "タイトル"
        t.string :description, limit: 1024, null: true,  index: false,                                 comment: "説明"
        t.string :hint_desc,                null: true,  index: false,                                 comment: "ヒント"
        t.string :source_author,            null: true,  index: false,                                 comment: "作者"
        t.string :source_media_name,        null: true,  index: false,                                 comment: "出典メディア"
        t.string :source_media_url,         null: true,  index: false,                                 comment: "出典URL"
        t.date :source_published_on,        null: true,  index: false,                                 comment: "出典年月日"
        t.belongs_to :source_about,         null: true,  foreign_key: {to_table: :wkbk_source_abouts}, comment: "所在"
        t.integer :turn_max,                null: true,  index: true,                                  comment: "最大手数"
        t.boolean :mate_skip,               null: true,                                                comment: "詰みチェックをスキップする"
        t.string :direction_message,        null: true,                                                comment: "メッセージ"

        t.timestamps

        t.integer :moves_answers_count, default: 0, null: false, index: false, comment: "解答数"
      end

      create_table :wkbk_source_abouts, force: true do |t|
        t.string :key,       null: false
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # MovesAnswer
      create_table :wkbk_moves_answers, force: true do |t|
        t.belongs_to :article, foreign_key: {to_table: :wkbk_articles}, null: false,               comment: "問題"
        t.integer :moves_count,                                         null: false, index: true,  comment: "N手"
        t.string :moves_str,                                            null: false, index: false, comment: "連続した指し手"
        t.string :end_sfen,                                             null: true,  index: false, comment: "最後の局面"
        t.string :moves_human_str,                                      null: true,  index: false, comment: "人間向け指し手"
        t.timestamps
      end

      ################################################################################

      create_table :wkbk_books, force: true do |t|
        t.string :key,                         null: false, index: true
        t.belongs_to :user,                    null: false, foreign_key: true,                      comment: "作成者"
        t.belongs_to :folder,                  null: false, foreign_key: {to_table: :wkbk_folders}, comment: "フォルダ"
        t.string :title,                       null: true,  index: false,                           comment: "タイトル"
        t.string :description, limit: 1024,    null: true,  index: false,                           comment: "説明"
        t.integer :articles_count, default: 0, null: false, index: false,                           comment: "記事数"
        t.timestamps
      end
    end

    if Rails.env.production? || Rails.env.staging? || Rails.env.development?
      Wkbk.setup
      if Rails.env.production? || Rails.env.staging?
        Wkbk::Article.import_all(max: 1000)
      end
      if Rails.env.development?
        Wkbk::Article.import_all(max: 50)
      end
    end
  end
end
