# user = User.create!
# book = user.wkbk_books.create!
# book.articles << user.wkbk_articles.create!(key: "a")
# book.articles << user.wkbk_articles.create!(key: "b")

module Wkbk
  module UserMod
    extend ActiveSupport::Concern

    included do
      # このユーザーが作成した問題(複数)
      has_many :wkbk_articles, class_name: "Wkbk::Article", dependent: :destroy do
        def create_mock1(attrs = {})
          create!(attrs) do |e|
            if e.moves_answer_validate_skip.nil?
              e.moves_answer_validate_skip = true
            end
            e.title ||= SecureRandom.hex
            e.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1"
            e.moves_answers.build(moves_str: "G*5b")
          end
        end
      end

      # このユーザーが作成した本(複数)
      has_many :wkbk_books, class_name: "Wkbk::Book", dependent: :destroy do
        def create_mock1(attrs = {})
          create!(attrs) do |e|
            e.title ||= SecureRandom.hex
            e.description ||= SecureRandom.hex
          end
        end
      end

      has_many :wkbk_bookships, class_name: "Wkbk::Bookship", dependent: :destroy # 作成した問題集中間情報
      has_many :wkbk_active_articles, through: :wkbk_bookships, source: :article, class_name: "Wkbk::Article"    # フォルダに入れた記事たち
      has_many :wkbk_active_books,    through: :wkbk_bookships, source: :book, class_name: "Wkbk::Book"          # 記事を入れられた問題集たち

      # このユーザーが解答した記録たち
      has_many :wkbk_answer_logs, class_name: "Wkbk::AnswerLog", dependent: :destroy
      has_many :wkbk_answered_articles, through: :wkbk_answer_logs, source: :article, class_name: "Wkbk::Article"
      has_many :wkbk_answered_books,    through: :wkbk_answer_logs, source: :book,    class_name: "Wkbk::Book"
      has_many :wkbk_answered_ox_marks, through: :wkbk_answer_logs, source: :ox_mark, class_name: "Wkbk::OxMark"
    end

    # def wkbk_book_create_mock(keys = [])
    #   book = user.wkbk_books.create!
    #   book.articles << user.wkbk_articles.create!(key: "a")
    #   book.articles << user.wkbk_articles.create!(key: "b")
    #   book
    # end

    concerning :UserInfoMethods do
      # rails r "tp User.first.wkbk_info"

      # def wkbk_active_articles_count
      #   wkbk_articles.active_only.count
      # end
      #
      # def wkbk_articles_good_rate_average
      #   wkbk_articles.average(:good_rate)
      # end
      #
      # def wkbk_articles_good_marks_total
      #   wkbk_articles.sum(:good_marks_count)
      # end
      #
      # def wkbk_articles_bad_marks_total
      #   wkbk_articles.sum(:bad_marks_count)
      # end

      def wkbk_total_o_count
        wkbk_answer_logs.with_o.count
      end

      def wkbk_total_x_count
        wkbk_answer_logs.with_ox_mark(:mistake).count
      end

      def wkbk_today_total_o_count
        wkbk_answer_logs.with_today.with_o.count
      end

      def wkbk_today_total_x_count
        wkbk_answer_logs.with_today.with_ox_mark(:mistake).count
      end

      def wkbk_today_total_o_ucount
        wkbk_answer_logs.with_today.with_o.distinct.count(:article_id)
      end

      def wkbk_today_total_x_ucount
        wkbk_answer_logs.with_today.with_ox_mark(:mistake).distinct.count(:article_id)
      end

      # rails r "tp User.first.wkbk_info"
      def wkbk_info
        {
          "ID"                 => id,
          "名前"               => name,
          "メールアドレス"     => email,
          "プロバイダ"         => auth_infos.collect(&:provider).join(" "),
          "Twitterアカウント"  => twitter_key,
          "最終ログイン日時"   => current_sign_in_at&.to_s(:distance),
          "登録日時"           => created_at&.to_s(:distance),
          "IP"                 => current_sign_in_ip,
          "タグ"               => permit_tag_list,
          # "最新シーズン情報ID" => wkbk_latest_xrecord.id,
          # "永続的プロフ情報ID" => wkbk_main_xrecord.id,
          # "部屋入室数"         => wkbk_room_memberships.count,
          # "対局数"             => wkbk_battle_memberships.count,
          "問題履歴数"         => wkbk_answer_logs.count,
          # "バトル中発言数"     => wkbk_room_messages.count,
          # "ロビー発言数"       => wkbk_lobby_messages.count,
          # "問題コメント数"     => wkbk_article_messages.count,

          "作成問題数"         => wkbk_articles.count,
          # "問題高評価率"       => wkbk_articles.average(:good_rate),
          # "問題高評価数"       => wkbk_articles.sum(:good_marks_count),
          # "問題低評価数"       => wkbk_articles.sum(:bad_marks_count),

          "問題正解数"         => wkbk_total_o_count,
          "問題不正解数"       => wkbk_total_x_count,

          "問題正解数(本日)"   => wkbk_today_total_o_count,
          "問題不正解数(本日)" => wkbk_today_total_x_count,

          "ユニーク問題正解数(本日)"   => today_total_o_ucount,
          "ユニーク問題不正解数(本日)" => today_total_x_ucount,
        }
      end
    end
  end
end
