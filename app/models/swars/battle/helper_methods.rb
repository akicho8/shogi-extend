module Swars
  class Battle
    concern :HelperMethods do
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

          # 「居飛車」という情報は戦法から自明なので戦法も囲いもないときだけ入れる
          if names.blank?
            names += e.tag_names_for(:note)
          end

          names = names.presence || ["その他"]
          names.join(" ")
        }.join(" vs ")

        out.join(" ")
      end
    end
  end
end
