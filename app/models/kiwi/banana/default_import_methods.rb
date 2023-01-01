module Kiwi
  class Banana
    concern :DefaultImportMethods do
      class_methods do
        # rails r 'Kiwi::Banana.default_data_import'
        # cap production rails:runner CODE='Kiwi::Banana.default_data_import'
        # cap production rails:runner CODE='p User.find_by(key: "932ed39bb18095a2fc73e0002f94ecf1")'
        # RAILS_ENV=production nohup bundle exec bin/rails r 'Kiwi::Banana.default_data_import' &
        def default_data_import(options = {})
          # options = {
          #   # create_only: false,
          # }.merge(options)

          # Banana.destroy_all
          # Lemon.destroy_all
          # exit

          # puts alpha_zero_vs_elmo_params_list.to_yaml
          import_all(alpha_zero_vs_elmo_params_list)
          # import_all(default_records_list)
        end

        # rails r 'pp Kiwi::Banana.alpha_zero_vs_elmo_params_list'
        def alpha_zero_vs_elmo_params_list
          [
            # { key: "Z8Yc9dPZek9", index: "?",  number: 1,  color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "RMl6paUAYM9", index: "1",  number: 12, color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "TAs1CTDPsvd", index: "2",  number: 17, color_theme_key: :is_color_theme_radial_gradiention2 },
            { key: "wIW3tnZMnUD", index: "3",  number: 18, color_theme_key: :is_color_theme_radial_gradiention3 },
            { key: "nVxSJI7tlap", index: "4",  number: 23, color_theme_key: :is_color_theme_radial_gradiention4 },
            { key: "qgeYRTJJ6tc", index: "5",  number: 32, color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "TW5vDpMXgXW", index: "6",  number: 35, color_theme_key: :is_color_theme_radial_gradiention2 },
            { key: "GDARn1MSPsu", index: "7",  number: 52, color_theme_key: :is_color_theme_radial_gradiention3 },
            { key: "TISYdaPlwhQ", index: "8",  number: 76, color_theme_key: :is_color_theme_radial_gradiention4 },
            { key: "q8Fsa72oSOs", index: "9",  number: 78, color_theme_key: :is_color_theme_radial_gradiention1 },
            { key: "Fyq37jDjjxV", index: "10", number: 81, color_theme_key: :is_color_theme_radial_gradiention2 },
          ].collect.with_index do |params|
            # tp params

            body = Rails.root.join("alpha_zero_vs_elmo", "#{params[:number]}.csa").read
            # body = "68S"

            info = Bioshogi::Parser.parse(body)
            # versus = "#{info.formatter.mi.header["先手"]} vs #{info.formatter.mi.header["後手"]}"
            versus = "AlphaZero vs elmo"
            black_white = "先手:#{info.formatter.mi.header["先手"]} 後手:#{info.formatter.mi.header["後手"]}"
            judgment_message = info.formatter.judgment_message.remove(/^まで/).gsub(/先手|後手/, info.formatter.mi.header.to_h)

            {
              :key  => params[:key],
              :body => body,
              :all_params => {
                :media_builder_params => {
                  :recipe_key      => "is_recipe_mp4",
                  :color_theme_key => params[:color_theme_key], # ColorGradientInfo.fetch(i.modulo(ColorGradientInfo.count)).key,
                  :audio_theme_key => "is_audio_theme_ds3479",
                  :cover_text      => "羽生善治特選 ##{params[:index]}\n#{versus} 100番勝負 第#{params[:number]}局\n#{black_white}\n#{judgment_message}",
                  :turn_embed_key  => "is_turn_embed_on",
                  :page_duration   => 1.0,
                  :end_duration    => 7,
                  :width           => 1920,
                  :height          => 1080,
                  :main_volume     => 0.8,
                  :viewpoint       => info.container.win_player.location.key, # 勝った方の視点にする
                },
              },
              :banana_params => {
                :folder_key    => "public",
                :title         => "##{params[:index]} 羽生善治特選 #{versus} 100番勝負 第#{params[:number]}局",
                :description   => "#{black_white}\n#{judgment_message}",
                :tag_list      => ["AlphaZero", "elmo", "羽生善治", *info.container.normalized_names_with_alias],
                :thumbnail_pos => 1 + (info.container.outbreak_turn || info.container.turn_info.turn_offset) # 歩と角以外の交換がある直前の局面
              },
            }
          end
        end

        # rails r 'pp Kiwi::Banana.default_records_list'
        def default_records_list
          ImportItems.collect do |e|
            if e[:source_file]
              e[:body] = Pathname(e[:source_file]).read
            end
            e
          end
        end

        def import_all(list)
          list.each do |e|
            import_one(e)
          end
        end

        def import_one(xparams)
          if xparams[:key].blank?
            raise ArgumentError, xparams.inspect
          end

          Bioshogi.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))

          user = User.find_by(key: "932ed39bb18095a2fc73e0002f94ecf1") || User.sysop

          free_battle = nil
          lemon = nil
          if banana = user.kiwi_bananas.find_by(key: xparams[:key])
            lemon = banana.lemon
            free_battle = lemon.recordable
          end
          if lemon
          else
            free_battle = user.free_battles.create!(kifu_body: xparams[:body], use_key: "kiwi_lemon")
            lemon = user.kiwi_lemons.build(recordable: free_battle)
          end
          lemon.update!(all_params: xparams[:all_params])
          lemon.main_process

          banana ||= user.kiwi_bananas.build(lemon: lemon, key: xparams[:key])
          banana.send(:attribute_will_change!, :thumbnail_pos) # サムネを作り直す
          banana.update!(xparams[:banana_params])

          tp banana
        end
      end
    end
  end
end
