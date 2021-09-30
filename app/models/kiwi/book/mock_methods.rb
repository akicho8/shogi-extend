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

        # rails r 'Kiwi::Book.mock_setup'
        def mock_setup
          params1 = {
            :body => "position startpos moves 7g7f 8c8d",
            :all_params => {
              :media_builder_params => {
                :recipe_key      => "is_recipe_mp4",
                :audio_theme_key => "audio_theme_is_none",
                :color_theme_key => "color_theme_is_real_wood1",
                :cover_text => "(cover_text.title)\n(cover_text.description)",
                # :width           => 2,
                # :height          => 2,
              },
            },
          }

          [
            { key: 1, user: :sysop, folder_key: :public,  },
            { key: 2, user: :sysop, folder_key: :private, },
            { key: 3, user: :bot,   folder_key: :public,  },
            { key: 4, user: :bot,   folder_key: :private, },
          ].each do |e|

            user = User.public_send(e[:user])
            title = "#{e[:user]} - #{e[:folder_key]} - #{e[:key]}"

            Lemon.where(id: e[:key]).destroy_all
            free_battle = user.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
            lemon1 = user.kiwi_lemons.create!(recordable: free_battle, all_params: params1[:all_params])
            lemon1.main_process

            Book.where(key: e[:key]).destroy_all
            book = user.kiwi_books.create!(key: e[:key], lemon: lemon1, folder_key: e[:folder_key], title: title, tag_list: e.values.join(" "))

            book.book_messages.create!(user: user, body: "(body)")
          end
        end
      end
    end
  end
end
