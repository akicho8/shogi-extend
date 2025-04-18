class CreateWkbk < ActiveRecord::Migration[6.0]
  def change
    ForeignKey.disabled do
      ################################################################################ 静的

      # フォルダ
      create_table :wkbk_folders, force: true do |t|
        t.string :key, null: false, index: { unique: true }
        t.integer :position, null: false, index: true
        t.integer :books_count,    default: 0, null: false, index: false, comment: "問題集数"
        t.integer :articles_count, default: 0, null: false, index: false, comment: "問題数"
        t.timestamps
      end

      # 問題の種類
      create_table :wkbk_lineages, force: true do |t|
        t.string :key, null: false, index: { unique: true }
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # 出題順序
      create_table :wkbk_sequences, force: true do |t|
        t.string :key, null: false, index: { unique: true }
        t.integer :position, null: false, index: true
        t.timestamps
      end

      # 解答種類
      create_table :wkbk_answer_kinds, force: true do |t|
        t.string :key, null: false, index: { unique: true }
        t.integer :position, null: false, index: true
        t.timestamps
      end

      ################################################################################

      create_table :wkbk_bookships, force: true do |t|
        t.belongs_to :user,    foreign_key: true,                       null: false, comment: "作成者"
        t.belongs_to :book,    foreign_key: { to_table: :wkbk_books },    null: false, comment: "問題集"
        t.belongs_to :article, foreign_key: { to_table: :wkbk_articles }, null: false, comment: "問題"
        t.integer :position, null: false, index: true
        t.timestamps
        t.index [:book_id, :article_id], unique: true
      end

      create_table :wkbk_articles, force: true do |t|
        t.string :key,                      null: false, index: { unique: true }

        t.belongs_to :user,                 null: false, foreign_key: true,                            comment: "作成者"
        t.belongs_to :folder,               null: false, foreign_key: { to_table: :wkbk_folders },       comment: "フォルダ"
        t.belongs_to :lineage,              null: false, foreign_key: { to_table: :wkbk_lineages },      comment: "種類"
        # t.belongs_to :book,                 null: true,  foreign_key: {to_table: :wkbk_books},         comment: "本"

        t.string :init_sfen,                null: false, index: true,                                  comment: "問題"
        t.string :viewpoint,                null: false, index: false,                                 comment: "視点"
        t.string :title, limit: 100,        null: false, index: false,                                 comment: "タイトル"
        t.text   :description, limit: 5000, null: false, index: false,                                 comment: "説明"
        t.string :direction_message, limit: 100, null: false,                                                comment: "メッセージ"
        t.integer :turn_max,                null: false, index: true,                                  comment: "最大手数"
        t.boolean :mate_skip,               null: false,                                                comment: "詰みチェックをスキップする"
        t.integer :moves_answers_count, default: 0, null: false, index: false, comment: "解答数"
        # t.integer :position, null: false, index: true
        t.integer :difficulty,       null: false,  index: true,                                  comment: "難易度"

        t.integer :answer_logs_count, default: 0, null: false, index: false, comment: "解答数"
        t.timestamps
      end

      # MovesAnswer
      create_table :wkbk_moves_answers, force: true do |t|
        t.belongs_to :article, foreign_key: { to_table: :wkbk_articles }, null: false,               comment: "問題"
        t.integer :moves_count,                                         null: false, index: true,  comment: "N手"
        t.text :moves_str,        limit: 1000,                          null: false, index: false, comment: "連続した指し手"
        t.text :moves_human_str,  limit: 1000,                          null: true,  index: false, comment: "人間向け指し手"
        t.integer :position, null: false, index: true
        t.timestamps
      end

      create_table :wkbk_books, force: true do |t|
        t.string     :key,                          null: false, index: { unique: true }
        t.belongs_to :user,                         null: false, foreign_key: true,                        comment: "作成者"
        t.belongs_to :folder,                       null: false, foreign_key: { to_table: :wkbk_folders },   comment: "フォルダ"
        t.belongs_to :sequence,                     null: false, foreign_key: { to_table: :wkbk_sequences }, comment: "順序"
        t.string     :title,       limit: 100,      null: false,                                           comment: "タイトル"
        t.text       :description, limit: 5000,     null: false,                                           comment: "説明"
        t.integer    :bookships_count,  default: 0, null: false,                                           comment: "記事数"
        t.integer    :answer_logs_count, default: 0, null: false,                                           comment: "解答数"
        t.timestamps
      end

      create_table :wkbk_answer_logs, force: true do |t|
        t.belongs_to :article,     foreign_key: { to_table: :wkbk_articles },     null: false, comment: "出題"
        t.belongs_to :answer_kind, foreign_key: { to_table: :wkbk_answer_kinds }, null: false, comment: "解答"
        t.belongs_to :book,        foreign_key: { to_table: :wkbk_books },        null: false, comment: "対戦部屋"
        t.belongs_to :user,        foreign_key: true,                           null: false, comment: "自分"
        t.integer    :spent_sec, index: true,                                   null: false, comment: "使用時間"
        t.datetime :created_at,  index: true,                                   null: false
      end
    end

    # if Rails.env.production? || Rails.env.staging? || Rails.env.development?
    #   Wkbk.setup
    #   if Rails.env.production? || Rails.env.staging?
    #     Wkbk::Article.import_all(max: 1000)
    #   end
    #   if Rails.env.development?
    #     Wkbk::Article.import_all(max: 50)
    #   end
    # end
  end
end
