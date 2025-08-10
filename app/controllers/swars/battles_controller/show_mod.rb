module Swars
  class BattlesController
    concern :ShowMod do
      private

      def current_record
        @current_record ||= yield_self do
          if key = params[:id].presence
            key = BattleKey.create(key) # 不正なIDはここで例外になるので本家にアクセスはいかない
            if !from_crawl_bot?
              Importer::BattleImporter.new(key: key, BattleNotFound: params[:BattleNotFound]).call # すでにあるならskipしている
            end
            Battle.find_by!(key: key)
          else
            Battle.new
          end
        end
      end

      def js_record_for(e)
        a = super

        # battle
        a[:final_info]  = { key: e.final_info.key, name: e.final_info.name, :class => e.final_info.has_text_color, }
        a[:preset_info] = { name: e.preset_info.name, handicap_shift: e.preset_info.handicap_shift                 }
        a[:rule_info]   = { name: e.rule_info.name                                                                 }
        a[:xmode_info]  = { key: e.xmode.key, name: e.xmode.name                                                   }
        a[:imode_info]  = { key: e.imode.key, name: e.imode.name                                                   }

        # memberships

        memberships = ordered_memberships(e, e.memberships)
        main_membership = memberships.first

        if current_swars_user
          a[:judge] = { key: main_membership.judge_key }
        end

        a[:memberships] = js_memberships(e, memberships)
        a[:grade_diff]  = main_membership.grade_diff

        a
      end

      # 先後 http://localhost:4000/swars/search?query=YamadaTaro&viewpoint=white
      # 対象 http://localhost:4000/swars/search?query=YamadaTaro
      # 勝者 http://localhost:4000/swars/search?query=&all=true&per=50&debug=true
      def ordered_memberships(e, v)
        if current_viewpoint
          # 視点指定があるならそれ
          if current_viewpoint == :white
            v = v.reverse
          end
        elsif current_swars_user
          # 検索中ならその対象者を左側にする
          if v.last.user == current_swars_user
            v = v.reverse
          end
        elsif e.win_user_id
          # それ以外は勝者を左側にする
          if v.last.judge_key == "win" # 対象者がいないときは勝った方を左
            v = v.reverse
          end
        end
        v
      end

      def js_memberships(battle, memberships)
        memberships.collect do |e|
          hv = {
            :user                  => { key: e.user.key, ban_at: e.user.ban_at },
            :grade_info            => { name: e.grade.name },
            :location_key          => e.location_key,
            :judge_key             => e.judge_key,
            :badge_params          => e.badge_params(params),
            :ek_score_without_cond => e.ek_score_without_cond,
            :ek_score_with_cond    => e.ek_score_with_cond,
          }
          if e.style
            hv[:style_key] = e.style.key
          end
          [:attack, :defense, :technique, :note].each do |key|
            hv["#{key}_tag_list"] = e.tag_names_for(key)
          end
          hv
        end
      end
    end
  end
end
