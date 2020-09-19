module Api
  class ThreeStageLeaguePlayersController < ::Api::ApplicationController
    # self.script_name = "奨励会三段リーグ(個人別)"

    # http://0.0.0.0:3000/api/three_stage_league_player
    def show
      if current_uesr
        # html_title_set(page_title)
        # ogp_params_set

        s = current_uesr.memberships
        s = s.joins(:league).order(Tsl::League.arel_table[:generation].asc)
        s = s.includes({:user => :memberships}, :league)

        memberships = s

        data = {
          labels: memberships.collect { |e| e.league.generation },
          datasets: [
            {
              label: current_uesr.name,
              data: memberships.collect { |e| e.win },
            },
          ],
        }

        render json: {
          current_user_name: current_user_name,
          chart_data: data.as_json,
          memberships: s.as_json({
              include: [
                :user,
                :league,
              ],
              methods: [
                :ox_human,
                :seat_count,
                :goal_p,
              ],
              except: [
                :league_id,
                :user_id,
              ],
            }),
        }

        #
        # out = ""
        # out += h.javascript_tag(%(document.addEventListener('DOMContentLoaded', () => { new Vue({}).$mount("#app") })))
        # out += %(<div id="app"><three_stage_league_player_chart :info='#{info.to_json}' /></div>)
        # out += h.link_to("画像検索", user_name_google_image_search(current_uesr.name), :class => "button is-small",  target: "_blank")
        # out
      end
    end

    def form_parts
      [
        {
          :label   => "名前",
          :key     => :user_name,
          :elems   => Tsl::User.order(:name).inject({}) { |a, e| a.merge(e.name_with_age => e.name) },
          :type    => :select,
          :default => current_user_name,
        },
      ]
    end

    def current_user_name
      params[:user_name].presence || Tsl::User.order(:name).first&.name
    end

    def current_uesr
      if v = current_user_name
        Tsl::User.find_by!(name: v)
      end
    end
  end
end
