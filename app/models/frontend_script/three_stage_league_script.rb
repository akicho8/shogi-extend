module FrontendScript
  class ThreeStageLeagueScript < ::FrontendScript::Base
    self.script_name = "奨励会三段リーグ"

    def form_parts
      [
        {
          :label   => "第？回",
          :key     => :generation,
          :elems   => Tsl::Scraping.league_range.to_a.reverse,
          :type    => :select,
          :default => current_generation,
        },
      ]
    end

    def script_body
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
            row["名前"] = h.link_to(m.name_with_age, ThreeStageLeaguePlayerScript.script_link_path(user_name: m.user.name))
            row["勝"]   = m.win
            row["勝敗"] = [h.tag.small(m.ox_human, :class => "ox_sequense line_break_on"), h.tag.b(m.result_mark)].join(" ").html_safe
          end
        end

        [
          rows.to_html,
          h.link_to("本家", league.source_url, :class => "button is-small"),
        ].join(h.tag.br)
      end
    end

    def buttun_name
      "表示"
    end

    def current_generation
      (params[:generation].presence || Tsl::Scraping.league_range.last).to_i
    end
  end
end
