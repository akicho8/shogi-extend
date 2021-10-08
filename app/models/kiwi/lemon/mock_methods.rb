module Kiwi
  class Lemon
    concern :MockMethods do
      PARAMS_EXAMPLE_MP4 = {
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
            :color_theme_key          => "is_color_theme_real_wood1",
            :audio_theme_key          => "is_audio_theme_headspin_only",
            :factory_method_key        => "is_factory_method_ffmpeg",
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

      PARAMS_EXAMPLE_GIF = {
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
            :color_theme_key          => "is_color_theme_real_wood1",
            :audio_theme_key          => "is_audio_theme_headspin_only",
            :factory_method_key        => "is_factory_method_ffmpeg",
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

      class_methods do
        def setup(options = {})
          if Rails.env.development?
            mock_setup
          end
        end

        # rails r 'Kiwi::Lemon.mock_setup'
        def mock_setup
        end

        def mock_lemon
          raise if Rails.env.production? || Rails.env.staging?

          user1 = User.find_or_create_by!(name: "user1", email: "user1@localhost")
          lemon = user1.kiwi_lemons.create_mock1
          lemon
        end
      end
    end
  end
end
