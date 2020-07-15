module FrontendScript
  class ThreeStageLeagueScript < ::FrontendScript::Base
    self.script_name = "奨励会三段リーグ"

    def page_title
      "第#{current_generation}期 #{script_name}"
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

    def script_body
      html_title_set(page_title)
      ogp_params_set

      # 最新三段リーグは表示する直前でときどきクロールする
      if current_generation == Tsl::Scraping.league_range.last
        Rails.cache.fetch([self.class.name, current_generation].join("/"), :expires_in => 1.hour) do
          Tsl::League.generation_update(current_generation)
        end
      end

      if league = Tsl::League.find_by(generation: current_generation)
        memberships = league.memberships.includes(:user, :league).order(win: :desc, start_pos: :asc)

        if request.format.json?
          return memberships.as_json(include: [:user, :league], except: [:league_id, :user_id])
        end

        rows = memberships.collect do |m|
          {}.tap do |row|
            row["名前"] = h.link_to(m.name_with_age, ThreeStageLeaguePlayerScript.script_link_path(user_name: m.user.name), :class => name_class(m))
            row["勝"]   = m.win
            row["勝敗"] = [
              h.tag.span(m.ox_human, :class => "ox_sequense is_line_break_on"),
              h.tag.span(m.result_mark, :class => "has-text-danger is-size-7 has-text-weight-bold"),
            ].join(" ").html_safe
            row["在"] = m.user.memberships_count
            row[""] = h.link_to(h.tag.i(:class => "mdi mdi-account-question mr-2"), user_name_google_image_search(m.user.name), target: "_blank")
          end
        end

        [
          rows.to_html,
          h.link_to("本家", league.source_url, :class => "button is-small", target: "_blank"),
        ].join(h.tag.br)
      end
    end

    def buttun_name
      "表示"
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
  end
end
