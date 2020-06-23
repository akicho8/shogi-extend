module Swars
  concern :ShowMod do
    included do
      prepend_before_action only: :show do
        if bot_agent?
          if v = params[:id].presence
            unless current_scope.where(key: v).exists?
              raise ActionController::RoutingError, "ページが見つかりません(for bot)"
            end
          end
        end
      end
    end

    def show
      # クローラーが古いURLの /w/(user_key) 形式で跳んできたとき対策
      # http://localhost:3000/w/devuser1
      if v = params[:id].presence
        if User.where(user_key: v).exists?
          flash[:import_skip] = true
          redirect_to [:swars, :battles, query: v], alert: "URLを変更したのでトップにリダイレクトしました。お手数ですが新しい棋譜を取り込むには再度検索してください"
          return
        end
      end

      super
    end

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

      a[:tournament_name] = "将棋ウォーズ(#{e.rule_info.name})"

      a[:flip] = flip
      a[:modal_on_index_path] = e.modal_on_index_path(flip: flip)

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
