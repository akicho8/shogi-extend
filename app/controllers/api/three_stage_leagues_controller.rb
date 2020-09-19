module Api
  class ThreeStageLeaguesController < ::Api::ApplicationController
    # http://0.0.0.0:3000/api/three_stage_league
    def show
      # 最新三段リーグは表示する直前でときどきクロールする
      if current_generation == Tsl::Scraping.league_range.last
        Rails.cache.fetch([self.class.name, current_generation].join("/"), :expires_in => 1.hour) do
          Tsl::League.generation_update(current_generation)
        end
      end

      league = Tsl::League.find_by!(generation: current_generation)
      memberships = league.memberships.includes(:user, :league).order(win: :desc, start_pos: :asc)

      # if request.format.json?
      #   return memberships.as_json(include: [:user, :league], except: [:league_id, :user_id])
      # end

      # rows = memberships.collect do |m|
      #   {}.tap do |row|
      #     row["名前"] = h.link_to(m.name_with_age
      #     row["勝"]   = m.win
      #     row["勝敗"] = [
      #       h.tag.span(m.ox_human, :class => "ox_sequense is_line_break_on"),
      #       h.tag.span(m.result_mark, :class => "has-text-danger is-size-7 has-text-weight-bold"),
      #     ].join(" ").html_safe
      #     row["在"] = [m.user.seat_count(league.generation), m.user.memberships_count].join(" / ")
      #     row[""] = h.link_to(h.tag.i(:class => "mdi mdi-account-question mr-2"), user_name_google_image_search(m.user.name), target: "_blank")
      #   end
      # end

      #   [
      #     rows.to_html,
      #     h.link_to("本家", league.source_url, :class => "button is-small", target: "_blank"),
      #   ].join(h.tag.br)
      # end

      render json: {
        current_generation: current_generation,
        page_title: page_title,
        leagues: Tsl::League.all.as_json(only: [:generation]),
        league: league.as_json({
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
              :break_through_p,
            ],
            except: [
              :league_id,
              :user_id,
            ],
          }),
      }
    end

    def current_generation
      (params[:generation].presence || Tsl::Scraping.league_range.last).to_i
    end

    def name_class(m)
      if v = m.result_mark
        if v.include?("昇")
          "has-text-weight-bold"
        end
      end
    end

    def page_title
      "第#{current_generation}期 奨励会三段リーグ"
    end

    def form_parts
      [
        {
          :label   => "シーズン",
          :key     => :generation,
          :elems   => Tsl::Scraping.league_range.to_a.reverse,
          :type    => :select,
          :default => current_generation,
        },
      ]
    end
  end
end
