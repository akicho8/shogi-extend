module Kiwi
  class Banana
    concern :AlphaZeroVsElmoBuildMethods do
      class_methods do
        # rails r 'Kiwi::Banana.alpha_zero_vs_elmo_build'
        # cap production rails:runner CODE='Kiwi::Banana.alpha_zero_vs_elmo_build'
        # cap production rails:runner CODE='p User.find_by(key: "932ed39bb18095a2fc73e0002f94ecf1")'
        def alpha_zero_vs_elmo_build(options = {})
          options = {
            # create_only: false,
          }.merge(options)

          Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

          # Banana.destroy_all
          # Lemon.destroy_all

          tp Rails.env
          [
            # { key: "Z8Yc9dPZek9", number: 1, color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "RMl6paUAYM9", number: 12, color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "TAs1CTDPsvd", number: 17, color_theme_key: :is_color_theme_radial_gradiention2 },
            { key: "wIW3tnZMnUD", number: 18, color_theme_key: :is_color_theme_radial_gradiention3 },
            { key: "nVxSJI7tlap", number: 23, color_theme_key: :is_color_theme_radial_gradiention4 },
            { key: "qgeYRTJJ6tc", number: 32, color_theme_key: :is_color_theme_gradiention1 },
            { key: "TW5vDpMXgXW", number: 35, color_theme_key: :is_color_theme_gradiention2 },
            { key: "GDARn1MSPsu", number: 52, color_theme_key: :is_color_theme_gradiention3 },
            { key: "TISYdaPlwhQ", number: 76, color_theme_key: :is_color_theme_gradiention4 },
            { key: "q8Fsa72oSOs", number: 78, color_theme_key: :is_color_theme_plasma_blur1 },
            { key: "Fyq37jDjjxV", number: 81, color_theme_key: :is_color_theme_plasma_blur2 },
          ].each.with_index do |params, i|
            tp params

            user = User.find_by(key: "932ed39bb18095a2fc73e0002f94ecf1") || User.sysop

            body = Rails.root.join("alpha_zero_vs_elmo", "#{params[:number]}.csa").read
            # body = "68S"

            info = Bioshogi::Parser.parse(body)
            # versus = "#{info.header["先手"]} vs #{info.header["後手"]}"
            versus = "AlphaZero vs elmo"
            black_white = "先手:#{info.header["先手"]} 後手:#{info.header["後手"]}"
            judgment_message = info.judgment_message.remove(/^まで/).gsub(/先手|後手/, info.header.to_h)

            all_params = {
              :media_builder_params => {
                :recipe_key      => "is_recipe_mp4",
                :color_theme_key => params[:color_theme_key], # ColorGradientInfo.fetch(i.modulo(ColorGradientInfo.count)).key,
                :audio_theme_key => "is_audio_theme_ds3479",
                :cover_text      => "羽生善治厳選 ##{i.next}\n#{versus} 百番勝負 第#{params[:number]}局\n#{black_white}\n#{judgment_message}",
                :page_duration   => 1.0,
                :end_duration    => 7,
                :width           => 1920,
                :height          => 1080,
                :main_volume     => 0.3,
              },
            }

            free_battle1 = nil
            lemon1 = nil
            if banana1 = user.kiwi_bananas.find_by(key: params[:key])
              lemon1 = banana1.lemon
              free_battle = lemon1.recordable
            end
            if lemon1
            else
              free_battle1 = user.free_battles.create!(kifu_body: body, use_key: "kiwi_lemon")
              lemon1 = user.kiwi_lemons.build(recordable: free_battle1)
            end
            lemon1.update!(all_params: all_params)
            lemon1.main_process

            banana1 ||= user.kiwi_bananas.build(lemon: lemon1, key: params[:key])
            banana1.update!({
                :folder_key    => "public",
                :title         => "羽生善治厳選 ##{i.next} #{versus} 百番勝負 第#{params[:number]}局",
                :description   => "#{black_white}\n#{judgment_message}",
                :tag_list      => ["AlphaZero", "elmo", "羽生善治", *lemon1.recordable.all_tag_names],
                :thumbnail_pos => 1 + lemon1.recordable.adjust_turn,
              })

            tp banana1
          end

          tp Kiwi.info
        end
      end
    end
  end
end
