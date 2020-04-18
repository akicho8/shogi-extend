module Swars
  class PlayerInfosController < ApplicationController
    helper_method :current_swars_user_key
    helper_method :current_swars_user
    helper_method :js_swars_player_info_app_params
    helper_method :memberships_rule_key_group
    helper_method :attack_chart_params_list
    helper_method :defense_chart_params_list

    def index
      if bot_agent?
        return
      end

      if params[:stop_processing_because_it_is_too_heavy]
        return
      end

      if current_swars_user_key
        Battle.sometimes_user_import(user_key: current_swars_user_key, page_max: 5)
        unlet(:current_swars_user)
        unless current_swars_user
          flash.now[:warning] = "#{current_swars_user_key} さんの情報は見つかりませんでした"
          return
        end
        slack_message(key: "プレイヤー情報", body: current_swars_user.key)
      end
    end

    let :current_swars_user_key do
      params[:user_key].to_s.strip.presence
    end

    let :current_swars_user do
      User.find_by(user_key: current_swars_user_key)
    end

    let :js_swars_player_info_app_params do
      if current_swars_user
        scope = current_swars_user.memberships.joins(:battle).includes(:battle).reorder(created_at: :desc)

        {
          time_chart_params_list: [
            days_chart_params_for("days", "対局日時", scope.take(100)),
            days_chart_params_for("month", "直近1ヶ月", scope.where(Battle.arel_table[:battled_at].between(1.month.ago..Float::INFINITY))),
            days_chart_params_for("week", "直近1週間", scope.where(Battle.arel_table[:battled_at].between(7.days.ago..Float::INFINITY))),
          ],
          any_chart_params_list: ChartTagInfo.collect { |e| e.chart_params_for(current_swars_user) } + attack_chart_params_list + defense_chart_params_list + [
            {
              canvas_id: "rule_canvas",
              chart_params: {
                type: "pie",
                options: {
                  title: {
                    display: true,
                    text: "種類",
                  },
                },
                data: {
                  labels: RuleInfo.collect { |e| e.name },
                  datasets: [
                    {
                      data: RuleInfo.collect { |e| memberships_rule_key_group[e.key.to_s] || 0 },
                      backgroundColor: RuleInfo.collect.with_index { |e, i| PaletteInfo[i].pie_color },
                    },
                  ],
                },
              },
            },
            {
              canvas_id: "combination_canvas",
              chart_params: {
                type: "pie",
                options: {
                  title: {
                    display: true,
                    text: "組手",
                  },
                },
                data: {
                  labels: CombinationInfo.keys,
                  datasets: [
                    {
                      data: CombinationInfo.collect { |e| current_swars_user.memberships.tagged_with(e.key, on: :note_tags).count },
                      backgroundColor: CombinationInfo.collect.with_index { |e, i| PaletteInfo[i].pie_color },
                    },
                  ],
                },
              },
            },
            {
              canvas_id: "faction_canvas",
              chart_params: {
                type: "pie", # doughnut
                options: {
                  title: {
                    display: true,
                    text: "党派",
                  },
                },
                data: {
                  labels: FactionInfo.keys,
                  datasets: [
                    {
                      data: FactionInfo.collect { |e| current_swars_user.memberships.tagged_with(e.key, on: :note_tags).count },
                      backgroundColor: FactionInfo.collect.with_index { |e, i| PaletteInfo[i].pie_color },
                    },
                  ],
                },
              },
            },
          ],
        }
      end
    end

    let :memberships_rule_key_group do
      current_swars_user.battles.group("rule_key").count
    end

    let :attack_chart_params_list do
      any_chart_params_list_for(:attack)
    end

    let :defense_chart_params_list do
      any_chart_params_list_for(:defense)
    end

    private

    def days_chart_params_for(key, name, memberships)
      {
        name: name,
        canvas_id: "#{key}_canvas",
        chart_params: {
          type: "line",
          # options: {
          #   title: {
          #     display: true,
          #     text: "a",
          #   },
          # },
          data: {
            datasets: WinLoseInfo.collect.with_index { |wl, i|
              {
                label: wl.name,
                data: memberships.find_all { |e| e.judge_key.to_sym == wl.key }.collect { |e| { t: e.battle.battled_at.midnight.to_s(:ymdhms), y: e.battle.battled_at.hour * 1.minute + e.battle.battled_at.min } },
                backgroundColor: wl.palette.background_color,
                borderColor: wl.palette.border_color,
                pointRadius: 4,           # 点半径
                borderWidth: 2,           # 点枠の太さ
                pointHoverRadius: 5,      # 点半径(アクティブ時)
                pointHoverBorderWidth: 3, # 点枠の太さ(アクティブ時)
                fill: false,
                showLine: false,          # 線で繋げない
              }
            },
          },
        },
      }
    end

    def any_chart_params_list_for(type)
      tags_key = "#{type}_tags"
      list = current_swars_user.memberships.tag_counts_on(tags_key, :order => "count desc", limit: 5)
      list.collect.with_index do |tag, i|
        {
          canvas_id: "#{type}_chart_canvas#{i}",
          chart_params: {
            type: "pie",
            options: {
              title: {
                display: true,
                text: tag.name,
              },
            },
            data: {
              labels: WinLoseInfo.collect(&:name),
              datasets: [
                {
                  data: WinLoseInfo.collect { |e| current_swars_user.memberships.tagged_with(tag.name, on: tags_key).where(judge_key: e.key).count },
                  backgroundColor: WinLoseInfo.collect { |e| e.palette.pie_color },
                },
              ],
            },
          },
        }
      end
    end

    def slow_processing_error_redirect_url
      [:swars, :player_infos, user_key: current_swars_user_key, stop_processing_because_it_is_too_heavy: 1]
    end
  end
end
