# frozen-string-literal: true

# http://localhost:4000/lab/general/pre-professional-league

module QuickScript
  module General
    class PreProfessionalLeagueScript < Base
      self.title = "奨励会三段リーグDB"
      self.description = "奨励会三段リーグの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = :force_reload
      self.json_link = true

      def header_link_items
        super + [
          { name: "グラフ", icon: "chart-box", _v_bind: { href: "/lab/general/pre-professional-league.html", target: "_self", }, },
        ]
      end

      def form_parts
        super + [
          {
            :label   => "弟子名で絞り込み (部分一致・複数指定はAND条件)",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].presence,
                :placeholder => "藤 -佐",
                :help_message => %("a -b c -d" → a と c を含むが b と d は除く。例: "藤 -佐" →「藤井」や「伊藤」はマッチするが「佐藤」は除く),
              }
            },
          },
          {
            :label   => "このシーズンのメンバー (複数指定はOR条件)",
            :key     => :season_key,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:season_key].presence,
                :placeholder => "58 59 60",
                :help_message => %(例: "58 59 60" → 58〜60期のどこかに在籍していたメンバーで絞る)
              }
            },
          },
          {
            :label   => "この棋士の同期 (完全一致・複数指定はOR条件)",
            :key     => :user_name,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:user_name].presence,
                :placeholder => "藤井聡太 伊藤匠",
                :help_message => %(例: "藤井聡太 伊藤匠" → 藤井聡太か伊藤匠と当たったかもしれないメンバーで絞る ※本人を含む)
              }
            },
          },
          {
            :label   => "この師匠の弟子 (完全一致・複数指定はOR条件)",
            :key     => :mentor_name,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:mentor_name].presence,
                :placeholder => "井上 森信",
                :help_message => %(例: "井上 森信" → "井上か森信の門下で絞る ※表記にばらつきがあるため正確ではない結果になる場合がある)
              }
            },
          },
        ]
      end

      # http://localhost:3000/api/lab/general/pre-professional-league.json?json_type=general
      def as_general_json
        {
          "総合成績" => as_general_json_list,
          "成績行列" => as_general_json_matrix,
          "シーズン" => as_general_json_seasons,
        }
      end

      # R 側では未使用だけど誰かが使うかもしれないので入れている
      def as_general_json_list
        current_scope.collect do |user|
          {
            "弟子" => user.name,
            "師匠" => user.mentor&.name,
            "期間" => user.memberships_count,
            "期→" => user.memberships_first.try { season.key.name },
            "←期" => user.memberships_last.try { season.key.name },
            "齢→" => user.age_min,
            "←齢" => user.age_max,
            "次点" => user.runner_up_count,
            "最勝" => user.win_max,
            "勝率" => user.win_ratio,
            "状況" => user.rank.pure_info.short_name,
            "昇齢" => user.promotion_age,
            "昇期" => user.promotion_season_position,
            "昇勝" => user.promotion_win,
            # このネストした形式は R の前処理がややこしくなりすぎて自分にはさっぱりわからんので R 側では「成績行列」の方だけを使っている
            "成績" => user.memberships.inject({}) { |a, m| a.merge(m.season.key.name => m.win) },
          }
        end
      end

      def as_general_json_seasons
        active_seasons.collect do |e|
          {
            "名前" => e.key.name,
            "順序" => e.position,
          }
        end
      end

      # memberships の順番は不確定なのでDBの状況によって変わる
      # したがって R 側で並べる必要がある
      def as_general_json_matrix
        current_scope.unscope(:order).json_order.flat_map do |user|
          user.memberships.collect do |membership|
            {
              "名前" => membership.user.name,
              "勝数" => membership.win,
              "結果" => membership.result.name,
              "シーズン名" => membership.season.key.name,
              "シーズンインデックス" => membership.season.position,
            }
          end
        end
      end

      def call
        params[:season_key] ||= Ppl::Season.latest_or_base_key.name

        rows = current_scope.collect do |user|
          {
            "弟子" => { _nuxt_link: user.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(user_name: user.name)) }, :class => user_css_class(user) },
            "師匠" => menter_name_of(user),
            "期間" => user.memberships_count,
            "期→" => user.memberships_first.try { season.key.name },
            "←期" => user.memberships_last.try { season.key.name },
            "齢→" => user.age_min,
            "←齢" => user.age_max,
            "次点" => user.runner_up_count,
            "最勝" => user.win_max || "?",
            "勝率" => user.win_ratio.try { "%.3f" % self },
            "状況" => user.rank.pure_info.short_name,
            "昇齢" => user.promotion_age,
            "昇期" => user.promotion_membership.try { season.key.name },
            "昇勝" => user.promotion_win,
            **season_every_win_count_of(user),
          }
        end
        simple_table(rows)
      end

      def menter_name_of(user)
        if false
          # 本当はリンクしたいが表示する値自体がソート対象値なのでリンクにしてしまうとソートできなくなる
          user.mentor ? { _nuxt_link: user.mentor.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(mentor_name: user.mentor.name)) }, :class => "is_decoration_off" } : ""
        else
          user.mentor&.name || ""
        end
      end

      def current_scope
        @current_scope ||= Ppl::User.search(params)
      end

      def memberships_hash
        @memberships_hash ||= yield_self do
          hv = Hash.new { |h, k| h[k] = {} }
          current_scope.each do |user|
            user.memberships.each do |membership|
              hv[membership.season][user.id] = membership
            end
          end
          hv
        end
      end

      # [77, 76, ...]
      def active_seasons
        # @active_seasons = Ppl::Season.order(:position).find(memberships_hash.keys)
        @active_seasons = memberships_hash.keys.sort_by { |e| -e.position }
      end

      def season_every_win_count_of(user)
        active_seasons.each_with_object({}) do |season, m|
          m["#{column_name_prefix_for_avoid_js_bad_spec}#{season.key}"] = memberships_hash.dig(season, user.id).try { win || "?" }
        end
      end

      def user_css_class(user)
        ["is_decoration_off", *user.rank.pure_info.table_css_class].join(" ")
      end

      ################################################################################

      def title
        @title ||= "#{super} (#{current_scope.count})"
      end

      ################################################################################

      def top_content
        v_stack([season_links, user_links, mentor_links], :class => "gap_small")
      end

      def season_links
        h_stack(:class => "gap_small") do
          blocks = Ppl::Season.latest_order.collect do |e|
            params = default_params.merge(season_key: e.key.name)
            { _nuxt_link: e.key.name, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => button_css_class.join(" ") }
          end
          [*blocks, all_link]
        end
      end

      def all_link
        { _nuxt_link: "ALL", _v_bind: { to: qs_nuxt_link_to(params: default_params) }, :class => button_css_class.join(" ") }
      end

      def user_links
        h_stack(:class => "gap_small") do
          Ppl::User.includes(:rank).link_order.collect do |e|
            params = default_params.merge(user_name: e.name)
            css_klass = [button_css_class, *e.rank.pure_info.nav_css_class]
            { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => css_klass.join(" ") }
          end
        end
      end

      def mentor_links
        h_stack(:class => "gap_small") do
          Ppl::Mentor.link_order.collect do |e|
            params = default_params.merge(mentor_name: e.name)
            css_klass = button_css_class
            { _nuxt_link: "#{e.name}(#{e.users_count})", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => css_klass.join(" ") }
          end
        end
      end

      def button_css_class
        @button_css_class ||= ["button", "is-small", "is-light"]
      end

      def default_params
        { user_name: "", season_key: "", mentor_name: "", query: "", __prefer_url_params__: 1 }
      end

      ################################################################################

      def bottom_content
        h_stack(:class => "gap_small") do
          Ppl::Season.latest_order.collect do |e|
            params = default_params.merge(season_key: e.key.name)
            { _link_to: e.key.name, _v_bind: { href: e.to_vo.url, target: "_blank" }, :class => button_css_class.join(" ") }
          end
        end
      end

      ################################################################################
    end
  end
end
