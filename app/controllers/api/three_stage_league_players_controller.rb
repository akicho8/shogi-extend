module Api
  class ThreeStageLeaguePlayersController < ::Api::ApplicationController
    # http://0.0.0.0:3000/api/three_stage_league_player.json
    def show
      unless main_user
        # FIXME: これはやっかい。どうしよう？
        render json: {}
        return
      end

      s = main_user.memberships
      s = s.joins(:league).order(Tsl::League.arel_table[:generation].asc)
      s = s.includes({:user => :memberships}, :league)

      memberships = s

      chart_data = {
        labels: memberships.collect { |e| e.league.generation },
        datasets: [
          {
            label: main_user.name,
            data: memberships.collect { |e| e.win },
          },
        ],
      }

      render json: {
        main_user: main_user.as_json(methods: [:name_with_age]),
        chart_data: chart_data.as_json,
        memberships: s.as_json({
            include: [
              :user,
              league: {only: [:generation]},
            ],
            methods: [
              :ox_human,
              :result_mark,
              :seat_count,
              :level_up_p,
              :level_down_p,
              :runner_up_p,
              :previous_runner_up_count,
            ],
            except: [
              :league_id,
              :user_id,
            ],
          }),
        users: Tsl::User.order(:name).as_json({
            only: [
              :name,
              :level_up_generation,
              :runner_up_count,
            ],
          }),
      }
    end

    def main_user
      if v = main_user_name
        Tsl::User.find_by(name: v)
      end
    end

    def main_user_name
      params[:name].presence || params[:user_name].presence || Tsl::User.order(:name).first&.name
    end
  end
end
