module Swars
  class PlayerInfosController < ApplicationController
    def index
      if params[:stop_processing_because_it_is_too_heavy]
        return
      end

      if current_user_key
        Battle.debounce_basic_import(user_key: current_user_key, page_max: 5)
        unless current_swars_user
          flash.now[:warning] = "#{current_user_key} さんの情報は見つかりませんでした"
          return
        end
        SlackAgent.message_send(key: "Wプレイヤー情報", body: "#{current_swars_user.user_key}")
      end
    end

    let :current_user_key do
      params[:user_key].to_s.strip.presence
    end

    let :current_swars_user do
      User.find_by(user_key: current_user_key)
    end

    let :js_swars_player_info_app_params do
      # s, e = current_swars_user.memberships.minmax_by { |e| e.battle.battled_at }
      # labels = (s.battle.battled_at.to_date..e.battle.battled_at.to_date).to_a

      scope = current_swars_user.memberships.joins(:battle).includes(:battle).reorder(created_at: :desc)

      {
        battle_chart_params: battle_chart_params(scope.take(100)),
        week_chart_params: battle_chart_params(scope.where(Battle.arel_table[:battled_at].between(7.days.ago..Float::INFINITY))),

        rule_chart_params: {
          type: "pie",
          data: {
            labels: RuleInfo.collect { |e| e.name },
            datasets: [
              {
                data: RuleInfo.collect { |e| memberships_rule_key_group[e.key.to_s] || 0 },
                # backgroundColor: RuleInfo.values.each_index.collect { |i| PaletteInfo[i].css_color },
              },
            ],
          },
        },

        grouper_chart_params: {
          type: "pie",
          data: {
            labels: grouper_keys,
            datasets: [
              {
                data: grouper_keys.collect { |e| current_swars_user.memberships.tagged_with(e, on: :note_tags).count },
              },
            ],
          },
        },

        faction_chart_params: {
          type: "pie", # doughnut
          data: {
            labels: faction_keys,
            datasets: [
              {
                data: faction_keys.collect { |e| current_swars_user.memberships.tagged_with(e, on: :note_tags).count },
              },
            ],
          },
        },
      }
    end

    let :memberships_rule_key_group do
      current_swars_user.battles.group("rule_key").count
    end

    let :grouper_keys do
      ["相居飛車", "対抗型", "相振り"]
    end

    let :faction_keys do
      ["居飛車", "振り飛車"]
    end

    private

    def battle_chart_params(memberships)
      {
        type: "line",
        data: {
          # labels: labels,
          datasets: [
            { label: "勝ち", scope: -> e { e.judge_key == "win"  }, borderColor: "hsl(171, 100%, 41%, 0.5)", backgroundColor: "hsl(171, 100%, 41%, 0.1)", },
            { label: "負け", scope: -> e { e.judge_key == "lose" }, borderColor: "hsl(348, 100%, 61%, 0.5)", backgroundColor: "hsl(348, 100%, 61%, 0.1)", },
          ].collect { |e|
            {
              label: e[:label],
              data: memberships.find_all(&e[:scope]).collect { |e| { t: e.battle.battled_at.to_s(:ymdhms), y: e.battle.battled_at.hour * 1.minute + e.battle.battled_at.min } },
              backgroundColor: e[:backgroundColor],
              borderColor: e[:borderColor],
              pointRadius: 7,           # 点半径
              borderWidth: 2,           # 点枠の太さ
              pointHoverRadius: 8,      # 点半径(アクティブ時)
              pointHoverBorderWidth: 3, # 点枠の太さ(アクティブ時)
              fill: false,
              showLine: false,          # 線で繋げない
            }
          },
        },
      }
    end

    def slow_processing_error_redirect_url
      [:swars, :player_infos, user_key: current_user_key, stop_processing_because_it_is_too_heavy: 1]
    end
  end
end
