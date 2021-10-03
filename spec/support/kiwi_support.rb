module KiwiSupport
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    before do
      Actb.setup
      Emox.setup
      Wkbk.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }
    let(:user2) { User.create!(name: "user2", email: "user2@localhost", confirmed_at: Time.current) }
    let(:user3) { User.create!(name: "user3", email: "user3@localhost", confirmed_at: Time.current) }

    let(:params1) {
      {
        :body => "position startpos moves 7g7f 8c8d",
        :all_params => {
          :sleep => 0,
          :raise_message => "",
          :media_builder_params => {
            :recipe_key               => "is_recipe_mp4",
            :loop_key                 => "is_loop_infinite",
            :page_duration            => 1,
            :end_duration             => 2,
            :viewpoint                => "black",
            :color_theme_key          => "color_theme_is_real_wood1",
            :audio_theme_key          => "audio_theme_is_headspin_only",
            :factory_method_key        => "ffmpeg",
            :cover_text               => "(cover_text)\n(description1)\n(description2)",
            :video_crf                => 23,
            :audio_bit_rate           => "128k",
            :main_volume              => 0.5,
            :width                    => 2,
            :height                   => 2,
            :renderer_override_params => { },
          },
        },
      }
    }

    let(:gif_params1) {
      {
        :body => "position startpos moves 7g7f 8c8d",
        :all_params => {
          :sleep => 0,
          :raise_message => "",
          :media_builder_params => {
            :recipe_key               => "is_recipe_gif",
            :loop_key                 => "is_loop_infinite",
            :page_duration            => 1,
            :end_duration             => 2,
            :viewpoint                => "black",
            :color_theme_key          => "color_theme_is_real_wood1",
            :audio_theme_key          => "audio_theme_is_headspin_only",
            :factory_method_key        => "ffmpeg",
            :cover_text               => "(cover_text)\n(description1)\n(description2)",
            :video_crf                => 23,
            :audio_bit_rate           => "128k",
            :main_volume              => 0.5,
            :width                    => 2,
            :height                   => 2,
            :renderer_override_params => { },
          },
        },
      }
    }
    
    
    let(:free_battle1) do
      user1.free_battles.create!(kifu_body: params1[:body], use_key: "kiwi_lemon")
    end

    let(:lemon1) do
      user1.kiwi_lemons.create!(recordable: free_battle1, all_params: params1[:all_params])
    end

    let(:book1) do
      user1.kiwi_books.create!(lemon: lemon1, title: "アヒル", description: "(description)", folder_key: "public", tag_list: ["a", "b"])
    end

    let(:book_message1) do
      user1.kiwi_book_message_speak(book1, "(message1)")
    end

    let(:access_log1) do
      book1.access_logs.create!(user: user1)
    end
  end
end
