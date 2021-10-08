module Kiwi
  class Book
    concern :MockMethods do
      class_methods do
        # rails r 'Kiwi.setup(force: true); tp Kiwi.info'
        # rails r 'tp Kiwi.info'
        def setup(options = {})
          if Rails.env.development?
            mock_setup
          end
        end

        # rails r 'Kiwi::Book.mock_setup2'
        def mock_setup2
          [
            { key: 1, user: :sysop, folder_key: :public,  },
            { key: 2, user: :sysop, folder_key: :limited, },
            { key: 3, user: :sysop, folder_key: :private, },
            { key: 4, user: :bot,   folder_key: :public,  },
            { key: 5, user: :bot,   folder_key: :limited, },
            { key: 6, user: :bot,   folder_key: :private, },
          ].each do |e|
            if Rails.env.development?
              tp e
            end

            params1 = {
              :body => "position startpos moves 7g7f 8c8d",
              :all_params => {
                :media_builder_params => {
                  :recipe_key      => "is_recipe_mp4",
                  :audio_theme_key => "is_audio_theme_dance_chain",
                  :color_theme_key => "is_color_theme_real_wood1",
                  :cover_text => "(cover_text.title)\n(cover_text.description)",
                  # :width           => 2,
                  # :height          => 2,
                },
              },
            }

            user = User.public_send(e[:user])
            title = "##{e[:key]} #{e[:user]} #{e[:folder_key]}"

            Lemon.where(id: e[:key]).destroy_all
            free_battle = user.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
            lemon1 = user.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
            lemon1.main_process

            Book.where(key: e[:key]).destroy_all
            book = user.kiwi_books.create!(key: e[:key], lemon: lemon1, folder_key: e[:folder_key], title: title, tag_list: e.values.join(" "))

            book.book_messages.create!(user: user,       body: "x" * 512)
            book.book_messages.create!(user: User.sysop, body: "あ" * 512)
            book.book_messages.create!(user: User.bot,   body: "表示してはいけない", deleted_at: Time.current)
            book.book_messages.create!(user: User.bot,   body: "https://example.com/")
            book.book_messages.create!(user: User.bot,   body: (1..20).to_a.join("\n"))

            book.access_logs.create!(user: User.sysop)
            book.access_logs.create!(user: user)
            book.access_logs.create!
          end
        end

        # rails r 'Kiwi::Book.mock_setup'
        def mock_setup
          DbCop.foreign_key_checks_disable

          mock_setup2

          RecipeInfo.each do |recipe_info|
            tp recipe_info.key
            user1 = User.sysop
            params1 = {
              :body => "position startpos moves 7g7f 8c8d",
              :all_params => {
                :media_builder_params => {
                  :recipe_key      => recipe_info.key,
                  :audio_theme_key => "is_audio_theme_nc97718",
                  :color_theme_key => "is_color_theme_real_wood1",
                  :cover_text      => "(cover_text.title)\n(cover_text.description)",
                },
              },
            }
            free_battle = user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
            lemon1 = user1.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
            lemon1.main_process
            book1 = user1.kiwi_books.create!(lemon: lemon1, title: "#{user1.name} - #{recipe_info.name}(#{user1.kiwi_books.count.next})", description: "あいうえお" * 40, tag_list: %w(居飛車 嬉野流 右玉), folder_key: "public")
            book1.book_messages.create!(user: user1, body: "#{recipe_info.name}に対するコメント")
          end

          tp Lemon
          tp Book
          tp BookMessage
          tp AccessLog

          tp Kiwi.info
        end
      end
    end
  end
end
