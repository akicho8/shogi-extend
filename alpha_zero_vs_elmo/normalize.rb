require "../setup"

Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

Pathname.glob("*.csa") do |e|
  info = Parser.parse(e)

  kif = info.to_kif
  e.sub_ext(".kif").write(kif)

  mp4 = info.to_animation_mp4({
      :page_duration   => 1.0,
      :end_duration    => 7,
      :color_theme_key => "is_color_theme_groovy_board_texture08",
      :audio_theme_key => "is_audio_theme_ds3479",
    })
  e.sub_ext(".mp4").write(mp4)

  puts e
  exit
end
