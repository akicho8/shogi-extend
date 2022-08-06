module Swars
  concern :ShowMethods do
    private

    def current_record
      @current_record ||= yield_self do
        if v = params[:id].presence
          if request.from_crawler?
          else
            current_model.single_battle_import(key: v, SwarsBattleNotFound: params[:SwarsBattleNotFound])
          end
          current_scope.find_by!(key: v)
        else
          current_scope.new
        end
      end
    end

    def js_record_for(e)
      a = super

      # battle
      a[:final_info]  = { name: e.final_info.name, :class => e.final_info.has_text_color,        }
      a[:preset_info] = { name: e.preset_info.name, handicap_shift: e.preset_info.handicap_shift }
      a[:rule_info]   = { name: e.rule_info.name                                                 }
      a[:xmode_info]  = { key: e.xmode.key, name: e.xmode.name }

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

    # 先後 http://localhost:4000/swars/search?query=Yamada_Taro&viewpoint=white
    # 対象 http://localhost:4000/swars/search?query=Yamada_Taro
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
          :user         => { key: e.user.key },
          :grade_info   => { name: e.grade.name },
          :location_key => e.location_key,
          :judge_key    => e.judge_key,
          :medal_params => e.medal_params(params),
        }
        [:attack, :defense].each do |key|
          hv["#{key}_tag_list"] = e.tag_names_for(key)
        end
        hv
      end
    end
  end
end
