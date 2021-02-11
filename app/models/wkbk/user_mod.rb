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

      has_many :wkbk_bookships, class_name: "::Wkbk::Bookship", dependent: :destroy # 作成した問題集中間情報
      has_many :wkbk_active_articles, through: :wkbk_bookships, source: :article, class_name: "::Wkbk::Article"    # フォルダに入れた記事たち
      has_many :wkbk_active_books,    through: :wkbk_bookships, source: :book, class_name: "::Wkbk::Book"          # 記事を入れられた問題集たち
    end

    concerning :UserInfoMethods do
      # rails r "tp User.first.wkbk_info"
      def wkbk_info
        {
          "ID"   => id,
          "名前" => name,
        }
      end
    end
  end
end
