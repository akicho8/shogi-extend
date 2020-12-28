module Swars
  concern :ShowMod do
    private

    let :current_record do
      if v = params[:id].presence
        unless request.from_crawler?
          current_model.single_battle_import(key: v)
        end
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    def js_record_for(e)
      a = super

      # battle

      a[:final_info]  = { name: e.final_info.name, :class => e.final_info.has_text_color,        }
      a[:preset_info] = { name: e.preset_info.name, handicap_shift: e.preset_info.handicap_shift }
      a[:rule_info]   = { name: e.rule_info.name                                                 }

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

    # 先後 http://0.0.0.0:4000/swars/search?query=Yamada_Taro&viewpoint=white
    # 対象 http://0.0.0.0:4000/swars/search?query=Yamada_Taro
    # 勝者 http://0.0.0.0:4000/swars/search?query=&all=true&per=50&debug=true
    def ordered_memberships(e, v)
      if current_viewpoint
        # 視点指定があるならそれ
        if current_viewpoint === :white
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
      memberships.collect do |battle|
        attrs = {
          :user         => { key: battle.user.key },
          :medal_params => battle.medal_params(params),
          :grade_info   => { name: battle.grade.name, priority: battle.grade.priority },
          :location     => { key: battle.location.key, hexagon_mark: battle.location.hexagon_mark },
          :judge        => { key: battle.judge_key, name: battle.judge_info.name },
        }
        [:attack, :defense].each do |key|
          attrs["#{key}_tag_list"] = battle.tag_names_for(key)
        end
        attrs
      end
    end
  end
end
