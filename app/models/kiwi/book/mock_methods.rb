module Kiwi
  class Book
    concern :MockMethods do
      class_methods do
        def setup(options = {})
          if Rails.env.development?
            mock_setup
          end
        end

        # rails r 'Kiwi::Book.mock_setup'
        def mock_setup
          [
            { key: 1, user: :sysop, folder_key: :public,  },
            { key: 2, user: :sysop, folder_key: :private, },
            { key: 3, user: :bot,   folder_key: :public,  },
            { key: 4, user: :bot,   folder_key: :private, },
          ].each do |e|
            user = User.public_send(e[:user])
            title = "#{e[:user]} - #{e[:folder_key]} - #{e[:key]}"

            Lemon.where(id: e[:key]).destroy_all
            lemon = user.kiwi_lemons.create!(key: e[:key], title: title, folder_key: e[:folder_key])

            Book.where(key: e[:key]).destroy_all
            book = user.kiwi_books.create!(key: e[:key], folder_key: e[:folder_key], title: title, tag_list: e.values.join(" "))
            # Article.where(key: e[:key]).destroy_all
            # book.articles << user.kiwi_articles.create!(key: e[:key], title: title, folder_key: e[:folder_key])
          end

          # user = User.find_or_create_by(name: "alice")
          # title = "非公開問題を含む公開動画"
          # user.kiwi_bookships.destroy_all
          # # user.kiwi_articles.destroy_all
          # user.kiwi_books.destroy_all
          # book = user.kiwi_books.create!(key: 5, folder_key: :public, title: title, sequence_key: :bookship_position_asc)
          # # book.articles << user.kiwi_articles.create!(key: "5-1", title: "(公開)",   folder_key: :public)
          # # book.articles << user.kiwi_articles.create!(key: "5-2", title: "(非公開)", folder_key: :private)
          # # book.articles << user.kiwi_articles.create!(key: "5-3", title: "(公開)",   folder_key: :public)
          #
          # user = User.find_or_create_by(name: "bob")
          # title = "sysopの解答履歴付き"
          # user.kiwi_bookships.destroy_all
          # user.kiwi_articles.destroy_all
          # user.kiwi_books.destroy_all
          # book = user.kiwi_books.create!(key: 6, folder_key: :public, title: title, sequence_key: :bookship_position_asc)
          # book.articles << user.kiwi_articles.create!(key: "6-1", title: "ox", folder_key: :public)
          # book.articles << user.kiwi_articles.create!(key: "6-2", title: "o",  folder_key: :public)
          # book.articles << user.kiwi_articles.create!(key: "6-3", title: "初", folder_key: :public)
          # correct = ::Kiwi::AnswerKind.fetch("correct")
          # mistake = ::Kiwi::AnswerKind.fetch("mistake")
          # answer_log = User.sysop.kiwi_answer_logs.create!(article: book.articles[0], answer_kind: correct, book: book, spent_sec: 1) # o
          # answer_log = User.sysop.kiwi_answer_logs.create!(article: book.articles[0], answer_kind: mistake, book: book, spent_sec: 2) # x
          # answer_log = User.sysop.kiwi_answer_logs.create!(article: book.articles[1], answer_kind: mistake, book: book, spent_sec: 3) # o
        end

        def mock_book
          raise if Rails.env.production? || Rails.env.staging?

          user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
          book = user1.kiwi_books.create_mock1
          book
        end
      end

      def mock_attrs_set
        if Rails.env.test?
          # self.init_sfen ||= "position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{Book.count.next}p 1"
          # if moves_answers.empty?
          #   moves_answers.build(moves_str: "G*5b")
          # end
        end
      end
    end
  end
end
