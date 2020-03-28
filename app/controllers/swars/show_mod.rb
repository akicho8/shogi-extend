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

    # def js_show_options
    #   super.merge({
    #       time_chart_params: {
    #         type: "line",
    #         data: {
    #           labels: (1..current_record.turn_max).to_a,
    #           datasets: current_record.memberships.collect.with_index { |e, i|
    #             {
    #               label: e.name_with_grade,
    #               data: e.time_chart_xy_list,
    #               borderColor: PaletteInfo[i].border_color,
    #               backgroundColor: PaletteInfo[i].background_color,
    #               borderWidth: 3,
    #               fill: true,
    #             }
    #           },
    #         },
    #         options: {
    #           # https://misc.0o0o.org/chartjs-doc-ja/general/responsive.html
    #           # responsive: true,
    #           # maintainAspectRatio: true,
    #           # elements: {
    #           #   line: {
    #           #     tension: 0, # ベジェ曲線無効
    #           #   },
    #           # },
    #           # animation: {
    #           #   duration: 0, # 一般的なアニメーションの時間
    #           # },
    #         },
    #       },
    #     })
    # end

    def js_record_for(e)
      a = super

      # a[:time_chart_params] = e.time_chart_params

      a[:final_info] = { name: e.final_info.name, url: swars_tag_search_path(e.final_info.name), "class": e.final_info.has_text_color, }
      a[:preset_info] = { name: e.preset_info.name, url: swars_tag_search_path(e.preset_info.name),  }
      a[:rule_info] = { name: e.rule_info.name,   url: swars_tag_search_path(e.rule_info.name),    }
      a[:official_swars_battle_url] = official_swars_battle_url(e)

      if AppConfig[:swars_side_tweet_copy_function]
        a[:swars_tweet_text] = e.swars_tweet_text
      end

      flip, memberships = e.left_right_memberships(current_swars_user)
      a[:memberships] = memberships.collect do |label, e|
        attrs = {
          user: {
            key: e.user.key,
          },
          label: label,
          medal_params: e.medal_params,
          name_with_grade: e.name_with_grade,
          query_user_url: polymorphic_path(e.user),
          swars_home_url: e.user.swars_home_url,
          google_search_url: google_search_url(e.user.user_key),
          twitter_search_url: twitter_search_url(e.user.user_key),
          location: { hexagon_mark: e.location.hexagon_mark },
          # position: e.position,
        }

        if AppConfig[:player_info_function]
          attrs[:player_info_path] = url_for([:swars, :player_infos, user_key: e.user.user_key, only_path: true])
        end

        [:attack, :defense].each do |key|
          # attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect do |e|
          #   { name: e, url: swars_tag_search_path(e) }
          # end

          attrs["#{key}_tag_list"] = e.tag_names_for(key).collect { |name|
            { name: name, url: url_for([:tactic_note, id: name]) }
          }

          # attrs["#{key}_tag_list"] = e.send("#{key}_tags").pluck(:name).collect do |e|
          #   { name: e, url: swars_tag_search_path(e) }
          # end
        end
        attrs
      end

      a[:flip] = flip
      a[:modal_on_index_url] = e.modal_on_index_url(flip: flip)

      if AppConfig[:columns_detail_show]
        # 左側にいるひとから見た右側の人の力差
        a[:grade_diff] = memberships.first.last.grade_diff
      end

      a
    end
  end
end
