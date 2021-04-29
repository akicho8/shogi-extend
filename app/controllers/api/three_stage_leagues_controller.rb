# FIXME: RESTにしないと方がいいんじゃないか？ 余計に管理しにくい

module Api
  class ThreeStageLeaguesController < ::Api::ApplicationController
    # http://0.0.0.0:3000/api/three_stage_league
    def show
      # リクエストされたリーグが存在しないか、
      # 最新の三段リーグだけ、ときどきクロールする
      if !current_league || current_league.newest_record?
        Rails.cache.fetch([self.class.name, current_generation].join("/"), :expires_in => 1.hour) do
          Tsl::League.generation_update(current_generation)
        end
      end

      memberships = current_league.memberships.includes(:user, :league).order(win: :desc, start_pos: :asc)

      render json: {
        page_title: page_title,
        leagues: Tsl::League.order(generation: :desc).as_json(only: [:generation]),
        league: current_league.as_json({
            only: [
              :generation,
            ],
            methods: [
              :source_url,
            ],
          }),
        memberships: memberships.as_json({
            include: [
              :user,
              :league,
            ],
            methods: [
              :name_with_age,
              :ox_human,
              :result_mark,
              :seat_count,
              :level_up_p,
              :level_down_p,
              :runner_up_p,
              :previous_runner_up_count,
              # :zaiseki_win_list,
            ],
            except: [
              :league_id,
              :user_id,
            ],
          }),
      }
    end

    def current_league
      @current_league ||= Tsl::League.find_by(generation: current_generation)
    end

    def current_generation
      (params[:generation].presence || Tsl::Scraping.league_range.last).to_i
    end

    def page_title
      "第#{current_generation}期 奨励会三段リーグ"
    end
  end
end
