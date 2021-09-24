module KiwiSupport
  extend ActiveSupport::Concern

  included do
    before :context do
      Actb.setup
      Emox.setup
      Wkbk.setup
    end

    let(:user1) { User.create!(name: "user1", email: "user1@localhost", confirmed_at: Time.current) }

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
            :cover_text               => "cover_text",
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
  end
end
