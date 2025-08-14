# frozen-string-literal: true

# http://localhost:4000/lab/general/pre-professional-league_season

module QuickScript
  module General
    class PreProfessionalLeagueScript < Base
      self.title = "奨励会三段リーグ早見表"
      self.description = "奨励会三段リーグの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = :force_reload
      self.json_link = true

      def form_parts
        super + [
          {
            :label   => "この棋士たちの同期を抽出する (完全一致・複数指定可)",
            :key     => :name_rel,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:name_rel].presence,
                :help_message => %(例: "西山朋佳 里見香奈")
              }
            },
          },
          {
            :label   => "この期のメンバーを抽出する (複数指定可)",
            :key     => :season_number_rel,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:season_number_rel].presence,
                :help_message => %(例: "58 59 60")
              }
            },
          },
          {
            :label   => "棋士名フィルタ",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].presence,
                :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。例: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない),
              }
            },
          },
        ]
      end

      def top_content
        v_stack([league_season_links, user_links], :class => "gap_small")
      end

      # http://localhost:3000/api/lab/general/pre-professional-league_season.json?json_type=general
      def as_general_json
        current_scope.collect do |user|
          {
            "名前"         => user.name,
            "昇段時の年齢" => user.promotion_age,
            "昇段時の期"   => user.promotion_season_number,
            "昇段時の勝数" => user.promotion_win,
            "在籍期間"     => user.memberships_count,
            "年齢から"     => user.age_min,
            "年齢まで"     => user.age_max,
            "次点回数"     => user.runner_up_count,
            "最大勝数"     => user.win_max,
            "成績"         => user.memberships.inject({}) { |a, m| a.merge(m.league_season.season_number => m.win) },
          }
        end
      end

      def call
        params[:season_number_rel] ||= Ppl::LeagueSeason.season_number_max

        rows = current_scope.collect do |e|
          {
            "名前" => { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: { name_rel: e.name, season_number_rel: "", query: "", __prefer_url_params__: 1 }) }, :class => e.promoted_or_rights ? "has-text-weight-bold" : nil },
            "期間" => e.memberships_count,
            "齢〜" => e.age_min,
            "〜齢" => e.age_max,
            "次点" => e.runner_up_count,
            "最勝" => e.win_max,
            "昇齢" => e.promotion_age,
            "昇期" => e.promotion_season_number,
            "昇勝" => e.promotion_win,
            **memberhip_fields(e),
          }
        end
        simple_table(rows)
      end

      def current_scope
        @current_scope ||= Ppl::User.search(params)
      end

      def memberships_hash
        @memberships_hash ||= yield_self do
          hv = {}
          current_scope.each do |user|
            user.memberships.each do |membership|
              season_number = membership.league_season.season_number
              hv[season_number] ||= {}
              hv[season_number][user.id] = membership
            end
          end
          hv
        end
      end

      # [77, 76, ...]
      def field_season_numbers
        @field_season_numbers ||= Range.new(*memberships_hash.keys.minmax).to_a.reverse
      end

      def memberhip_fields(user)
        field_season_numbers.each_with_object({}) do |season_number, m|
          value = nil
          if memberhip = memberships_hash.dig(season_number, user.id)
            value = memberhip.win
          end
          m["#{column_name_prefix}#{season_number}"] = value
        end
      end

      def title
        @title ||= "#{super} (#{current_scope.count})"
      end

      ################################################################################

      def league_season_links
        h_stack(:class => "gap_small") do
          blocks = Ppl::LeagueSeason.newest_order.collect do |e|
            params = default_params.merge(season_number_rel: e.season_number)
            { _nuxt_link: e.season_number, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-small is-light" }
          end
          [*blocks, all_link]
        end
      end

      def all_link
        { _nuxt_link: "ALL", _v_bind: { to: qs_nuxt_link_to(params: default_params) }, :class => button_css_class.join(" ") }
      end

      def user_links
        h_stack(:class => "gap_small") do
          Ppl::User.link_order.collect do |e|
            params = default_params.merge(name_rel: e.name)
            css_klass = button_css_class
            if e.promoted_or_rights
              css_klass += ["has-text-weight-bold"]
            end
            { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => css_klass.join(" ") }
          end
        end
      end

      def button_css_class
        @button_css_class ||= ["button", "is-small", "is-light"]
      end

      def default_params
        { name_rel: "", season_number_rel: "", query: "", __prefer_url_params__: 1 }
      end
    end
  end
end
