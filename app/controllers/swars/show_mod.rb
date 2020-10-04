module Swars
  concern :ShowMod do
    private

    let :current_record do
      if v = params[:id].presence
        current_model.single_battle_import(key: v)
        current_scope.find_by!(key: v)
      else
        current_scope.new
      end
    end

    def js_record_for(e)
      a = super

      flip, memberships = e.left_right_memberships(current_swars_user)

      if current_swars_user
        a[:judge] = { key: memberships.first.last.judge_key }
      end

      a[:flip] = flip

      # a[:time_chart_params] = e.time_chart_params

      # 左側にいるひとから見た右側の人の力差
      a[:grade_diff] = memberships.first.last.grade_diff

      a[:final_info]  = { name: e.final_info.name, :class => e.final_info.has_text_color, }
      a[:preset_info] = { name: e.preset_info.name, handicap_shift: e.preset_info.handicap_shift }
      a[:rule_info]   = { name: e.rule_info.name                                          }

      a[:memberships] = memberships.collect do |label, e|
        attrs = {
          label: label,
          user: { key: e.user.key },
          medal_params: e.medal_params,
          grade_info: { name: e.grade.name, priority: e.grade.priority },
          location: { key: e.location.key, hexagon_mark: e.location.hexagon_mark },
          judge: { key: e.judge_key },
        }
        [:attack, :defense].each do |key|
          attrs["#{key}_tag_list"] = e.tag_names_for(key)
        end

        attrs
      end

      a
    end
  end
end
