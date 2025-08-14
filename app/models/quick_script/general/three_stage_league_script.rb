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
            :label   => "この棋士たちと同期を抽出する (氏名完全一致・複数指定可)",
            :key     => :name_rel,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:name_rel].presence,
                # :help_message => %(この棋士と同期の棋士の情報を抽出する),
              }
            },
          },
          {
            :label   => "この期のメンバーを抽出する (複数指定可)",
            :key     => :generation_rel,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:generation_rel].presence,
                # :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。数字は期の指定とする。例1: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない。例2: "75 76" → 75期と76期に絡んでいる人),
                # :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。例: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない),
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
                # :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。数字は期の指定とする。例1: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない。例2: "75 76" → 75期と76期に絡んでいる人),
                :help_message => %("a -b c -d" → a と c を含むが b と d は含まない。例: "藤 -佐" → 藤井はマッチするが佐藤はマッチしない),
              }
            },
          },
        ]
      end

      def top_content
        v_stack([league_links, user_links], :class => "gap_small")
      end

      def call
        params[:generation_rel] ||= Tsl::League.max_generation

        # if fetch_index == 0 && params[:generation_rel].blank?
          #   params[:generation_rel] = Tsl::League.max_generation
        # end
        if request_get?
          rows = current_scope.collect do |e|
            {
              "名前" => { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: { name_rel: e.name, __prefer_url_params__: 1 }) }, :class => e.promoted_or_rights ? "has-text-weight-bold" : nil },
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
      end

      def current_scope
        scope = Tsl::User.all
        scope = scope.plus_minus_search(params[:query])

        # この棋士たち同期を抽出する (氏名完全一致・複数指定可)
        if target_users.present?
          target_users.each do |user|
            scope = scope.where(id: user.leagues.flat_map(&:user_ids))
          end
        end

        # この期の同期を抽出する (複数指定可)
        if target_leagues.present?
          target_leagues.each do |league|
            scope = scope.where(id: league.user_ids)
          end
        end

        scope = scope.includes(memberships: [:user, :league, :result])
        scope = scope.table_order
      end

      def target_users
        @target_users ||= Tsl::User.where(name: params[:name_rel].to_s.scan(/\S+/))
      end

      def memberships_hash
        @memberships_hash ||= yield_self do
          hv = {}
          current_scope.each do |user|
            user.memberships.each do |membership|
              generation = membership.league.generation
              hv[generation] ||= {}
              hv[generation][user.id] = membership
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

      ################################################################################

      def target_generations
        @target_generations ||= params[:generation_rel].to_s.scan(/\d+/).collect(&:to_i).to_set
      end

      def target_leagues
        @target_leagues ||= Tsl::League.where(generation: target_generations)
      end

      ################################################################################

      # def query
      #   @query ||= params[:query].to_s.scan(/\S+/).to_set
      # end

      ################################################################################

      def league_links
        h_stack(:class => "gap_small") do
          blocks = Tsl::League.newest_order.collect do |e|
            params = { name_rel: "", generation_rel: e.generation, query: "", __prefer_url_params__: 1 }
            { _nuxt_link: e.generation, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-small is-light" }
          end
          [*blocks, all_link]
        end
      end

      def all_link
        params = { name_rel: "", generation_rel: "", query: "", __prefer_url_params__: 1 }
        { _nuxt_link: "ALL", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => button_css_class.join(" ") }
      end

      def user_links
        h_stack(:class => "gap_small") do
          Tsl::User.link_order.collect do |e|
            params = { name_rel: e.name, generation_rel: "", query: "", __prefer_url_params__: 1 }
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

      ################################################################################
    end
  end
end
