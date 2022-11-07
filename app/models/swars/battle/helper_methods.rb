module Swars
  class Battle
    concern :HelperMethods do
      class_methods do
        # continuity_run_counter("xxx_api")
        def continuity_run_counter(key, options = {})
          options = {
            interval: 1.seconds,
          }.merge(options)

          counter = (Rails.cache.read(key) || 0).next
          Rails.cache.write(key, counter, expires_in: options[:interval])
          counter
        end

        # 汚い文字列から最初に見つけたURLを抽出
        def battle_url_extract(str)
          if str
            if url = URI.extract(str, ["http", "https"]).first
              if url.match?(%r{\.heroz\.jp/games/})
                url
              end
            end
          end
        end

        # 汚い文字列から最初に見つけたURLから対局キーを取得
        def battle_key_extract(str)
          if url = battle_url_extract(str)
            key = URI(url).path.split("/").last
            KeyVo.wrap(key)
          end
        end

        # 汚い文字列から最初に見つけたURLから対局キーを取得して最初の人を抽出
        def user_key_extract_from_battle_url(str)
          if key = battle_key_extract(str)
            key.user_keys.first
          end
        end
      end

      # def header_detail(h)
      #   if v = super
      #     v.merge("場所" => h.link_to(key, official_swars_battle_url, target: "_self"))
      #   end
      # end

      def piyo_shogi_base_params
        a = {}
        a[:game_name] = tournament_name
        names = memberships.collect(&:name_with_grade)
        a.update([:sente_name, :gote_name].zip(names).to_h)
        a
      end

      def tournament_name
        "将棋ウォーズ(#{rule_info.name})"
      end

      def title
        memberships.collect(&:name_with_grade).join(" vs ")
      end

      def description
        out = []
        # out << tournament_name
        # out << final_info.name
        out << memberships.collect { |e|
          names = []
          names += e.tag_names_for(:attack)
          names += e.tag_names_for(:defense)

          # 「居飛車」という情報は戦型から自明なので戦型も囲いもないときだけ入れる
          if names.blank?
            names += e.tag_names_for(:note) - (reject_tag_keys[:note] || [])
          end

          names = names.presence || ["その他"]
          names.join(" ")
        }.join(" vs ")

        out.join(" ")
      end
    end
  end
end
