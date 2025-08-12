# frozen-string-literal: true

# http://localhost:4000/lab/general/three-stage-league

module QuickScript
  module General
    class ThreeStageLeagueScript < Base
      self.title = "奨励会三段リーグ早見表"
      self.description = "アプリログの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = :force_reload
      self.per_page_default = 1000

      def form_parts
        super + [
          {
            :label   => "",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].presence,
                :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。数字は期の指定とする。例1: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない。例2: "75 76" → 75期と76期に絡んでいる人),
              }
            },
          },
        ]
      end

      def top_content
        v_stack([league_links, user_links], :class => "gap_small")
      end

      def call
        if fetch_index == 0 && params[:query].blank?
          params[:query] = Tsl::League.max_generation
        end

        rows = current_scope.collect do |e|
          {
            "名前"   => { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: { query: e.name, __prefer_url_params__: 1 }) }, :class => e.shoudan_p ? "has-text-weight-bold" : nil },
            "昇齢"   => e.promotion_age,
            "期間"   => e.memberships_count,
            "齢〜"   => e.min_age,
            "〜齢"   => e.max_age,
            "次点"   => e.runner_up_count,
            "昇期"   => e.promotion_generation,
            "昇勝"   => e.promotion_membership&.win,
            "最勝"   => e.memberships.collect(&:win).max,
            **memberhip_fields(e),
          }
        end
        simple_table(rows)
      end

      def current_scope
        scope = Tsl::User.all
        scope = scope.plus_minus_search(params[:query])
        scope = scope.includes(memberships: [:user, :league, :result])
        scope = scope.table_order
      end

      def memberships_hash
        @memberships_hash ||= yield_self do
          hv = {}
          current_scope.each do |user|
            user.memberships.each do |membership|
              hv[membership.league.generation] ||= {}
              hv[membership.league.generation][user.id] = membership
            end
          end
          hv
        end
      end

      # [77, 76, ...]
      def field_generations
        @field_generations ||= Range.new(*memberships_hash.keys.minmax).to_a.reverse
      end

      def memberhip_fields(user)
        field_generations.each_with_object({}) do |generation, m|
          value = nil
          if memberhip = memberships_hash.dig(generation, user.id)
            value = memberhip.win
          end
          m["#{column_name_prefix}#{generation}"] = value
        end
      end

      def title
        @title ||= "#{super} (#{current_scope.count})"
      end

      def all_link
        params = { query: "all", __prefer_url_params__: 1, page: 1 }
        { _nuxt_link: "ALL", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-small is-light" }
      end

      def league_links
        h_stack(:class => "gap_small") do
          blocks = Tsl::League.newest_order.collect do |e|
            params = { query: e.generation, __prefer_url_params__: 1, page: 1 }
            { _nuxt_link: e.generation, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-small is-light" }
          end
          [all_link, *blocks]
        end
      end

      def user_links
        h_stack(:class => "gap_small") do
          Tsl::User.link_order.collect do |e|
            params = { query: e.name, __prefer_url_params__: 1, page: 1 }
            css_klass = ["button", "is-small", "is-light"]
            if e.shoudan_p
              css_klass << "has-text-weight-bold"
            end
            { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => css_klass.join(" ") }
          end
        end
      end
    end
  end
end
