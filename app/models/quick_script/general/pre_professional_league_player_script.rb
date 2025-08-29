# frozen-string-literal: true

# http://localhost:4000/lab/general/pre-professional-league-player

module QuickScript
  module General
    class PreProfessionalLeaguePlayerScript < Base
      self.title = "奨励会三段リーグDB - 個別"
      self.description = "奨励会三段リーグの任意のプレイヤーの情報のみを表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = nil
      self.json_link = true
      self.parent_link = { force_link_to: "/lab/general/pre-professional-league" }

      # def header_link_items
      #   super + [
      #     { name: "グラフ", icon: "chart-box", _v_bind: { href: "/lab/general/pre-professional-league.html", target: "_self", }, },
      #   ]
      # end

      def form_parts
        super + [
          # {
          #   :label   => "弟子名で絞り込み (部分一致・複数指定はAND条件)",
          #   :key     => :query,
          #   :type    => :string,
          #   :dynamic_part => -> {
          #     {
          #       :default => params[:query].presence,
          #       :placeholder => "藤 -佐",
          #       :help_message => %("a -b c -d" → a と c を含むが b と d は除く。例: "藤 -佐" →「藤井」や「伊藤」はマッチするが「佐藤」は除く),
          #     }
          #   },
          # },
          # {
          #   :label   => "このシーズンのメンバー (複数指定はOR条件)",
          #   :key     => :season_key,
          #   :type    => :string,
          #   :dynamic_part => -> {
          #     {
          #       :default => params[:season_key].presence,
          #       :placeholder => "58 59 60",
          #       :help_message => %(例: "58 59 60" → 58〜60期のどこかに在籍していたメンバーで絞る)
          #     }
          #   },
          # },
          {
            :label   => "",
            :key     => :user_name,
            :type    => :string,
            :dynamic_part => -> {
              {
                :auto_complete_by => :html5,
                :elems            => Ppl::User.order(:name).pluck(:name),
                :default          => params[:user_name].presence,
                :placeholder      => "藤井聡太",
                # :help_message     => %(例: "藤井聡太 伊藤匠" → 藤井聡太か伊藤匠と当たったかもしれないメンバーで絞る ※本人を含む)
              }
            },
          },
          # {
          #   :label   => "この師匠の弟子 (完全一致・複数指定はOR条件)",
          #   :key     => :mentor_name,
          #   :type    => :string,
          #   :dynamic_part => -> {
          #     {
          #       :default => params[:mentor_name].presence,
          #       :placeholder => "井上 森信",
          #       :help_message => %(例: "井上 森信" → "井上か森信の門下で絞る ※表記にばらつきがあるため正確ではない結果になる場合がある)
          #     }
          #   },
          # },
        ]
      end

      # http://localhost:3000/api/lab/general/pre-professional-league-player.json?json_type=general&user_name=西山朋佳
      def as_general_json
        if target_user
          current_memberships.collect do |membership|
            {
              "年齢" => membership.age,
              "○期" => membership.season.key.name,
              "勝数" => membership.win,
              "敗数" => membership.lose,
              "結果" => membership.result.name,
              "勝敗" => membership.ox,
            }
          end
        end
      end

      # # R 側では未使用だけど誰かが使うかもしれないので入れている
      # def as_general_json_list
      #   target_user.collect do |user|
      #     {
      #       "弟子" => user.name,
      #       "師匠" => user.mentor&.name,
      #       "期間" => user.memberships_count,
      #       "期→" => user.memberships_first.try { season.key.name },
      #       "←期" => user.memberships_last.try { season.key.name },
      #       "齢→" => user.age_min,
      #       "←齢" => user.age_max,
      #       "次点" => user.runner_up_count,
      #       "最勝" => user.win_max,
      #       "勝率" => user.win_ratio,
      #       "状況" => user.rank.pure_info.short_name,
      #       "昇齢" => user.promotion_age,
      #       "昇期" => user.promotion_season_position,
      #       "昇勝" => user.promotion_win,
      #       # このネストした形式は R の前処理がややこしくなりすぎて自分にはさっぱりわからんので R 側では「成績行列」の方だけを使っている
      #       "成績" => user.memberships.inject({}) { |a, m| a.merge(m.season.key.name => m.win) },
      #     }
      #   end
      # end
      #
      # def as_general_json_seasons
      #   active_seasons.collect do |e|
      #     {
      #       "名前" => e.key.name,
      #       "順序" => e.position,
      #     }
      #   end
      # end
      #
      # # memberships の順番は不確定なのでDBの状況によって変わる
      # # したがって R 側で並べる必要がある
      # def as_general_json_matrix
      #   target_user.unscope(:order).json_order.flat_map do |user|
      #     user.memberships.collect do |membership|
      #       {
      #         "名前" => membership.user.name,
      #         "勝数" => membership.win,
      #         "結果" => membership.result.name,
      #         "シーズン名" => membership.season.key.name,
      #         "シーズンインデックス" => membership.season.position,
      #       }
      #     end
      #   end
      # end

      def call
        # params[:season_key] ||= Ppl::Season.latest_or_base_key.name
        if target_user
          rows = current_memberships.collect do |membership|
            {
              "年齢" => membership.age,
              "○期" => { _nuxt_link: membership.season.key.name, _v_bind: { to: qs_nuxt_link_to(qs_page_key: "pre_professional_league", params: { season_key: membership.season.key.name }) }, :class => "", },
              "勝数" => membership.win,
              "敗数" => membership.lose,
              "結果" => membership.result.pure_info.short_name,

              # "名前" => { _nuxt_link: user.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(user_name: user.name)) }, :class => user_css_class(user) },
              # "弟子" => { _nuxt_link: user.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(user_name: user.name)) }, :class => user_css_class(user) },
              # "師匠" => menter_name_of(user),
              # "状況" => user.rank.pure_info.short_name,
              # "勝率" => user.win_ratio.try { "%.3f" % self },
              # "昇齢" => user.promotion_age,
              # "昇勝" => user.promotion_win,
              # "最勝" => user.win_max || "?",
              #
              # "齢→" => user.age_min,
              # "←齢" => user.age_max,
              #
              # "期間" => user.memberships_count,
              # "期→" => user.memberships_first.try { season.key.name },
              # "←期" => user.memberships_last.try { season.key.name },
              #
              # "昇期" => user.promotion_membership.try { season.key.name },
              # "次点" => user.runner_up_count,
              # **season_every_win_count_of(user),
            }
          end
          simple_table(rows, always_table: true)
        end
      end

      def menter_name_of(user)
        if true
          # 本当はリンクしたいが表示する値自体がソート対象値なのでリンクにしてしまうとソートできなくなる
          user.mentor ? { _nuxt_link: user.mentor.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(mentor_name: user.mentor.name)) }, :class => "is_decoration_off" } : ""
        else
          user.mentor&.name || ""
        end
      end

      def target_user
        # @target_user ||= Ppl::User.search(params)
        @target_user ||= Ppl::User[params[:user_name]]
      end

      def current_memberships
        @current_memberships ||= yield_self do
          scope = target_user.memberships
          scope = scope.order(Ppl::Season.arel_table[:position].desc)
          scope = scope.includes(:season, :result)
        end
      end

      def memberships_hash
        @memberships_hash ||= yield_self do
          hv = Hash.new { |h, k| h[k] = {} }
          target_user.each do |user|
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
        if params[:matrix] == "false"
          return {}
        end
        active_seasons.each_with_object({}) do |season, m|
          m["#{column_name_prefix_for_avoid_js_bad_spec}#{season.key}"] = memberships_hash.dig(season, user.id).try { win || "?" }
        end
      end

      def user_css_class(user)
        ["is_decoration_off", *user.rank.pure_info.table_css_class].join(" ")
      end

      ################################################################################

      def title
        @title ||= yield_self do
          if target_user
            [
              target_user.name,
              target_user.rank.pure_info.short_name,
              target_user.win_ratio.try { "%.3f" % self },
            ].compact_blank.join(" ")
          else
            super
          end
        end
      end

      ################################################################################ top

      # def top_content
      #   v_stack([season_links, user_links, mentor_links], :class => "gap_small")
      # end

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
        { _nuxt_link: "ALL", _v_bind: { to: qs_nuxt_link_to(params: default_params.merge("matrix" => "false")) }, :class => button_css_class.join(" ") }
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

      def default_params
        { user_name: "", season_key: "", mentor_name: "", query: "", __prefer_url_params__: 1 }
      end

      ################################################################################ bottom

      # def bottom_content
      #   h_stack(:class => "gap_small") do
      #     Ppl::Season.latest_order.collect do |e|
      #       { _link_to: e.key.name, _v_bind: { href: e.key.url, target: "_blank" }, :class => button_css_class.join(" ") }
      #     end
      #   end
      # end

      ################################################################################

      def button_css_class
        @button_css_class ||= ["button", "is-small", "is-light"]
      end
    end
  end
end
# ~> -:7:in '<module:General>': uninitialized constant QuickScript::General::Base (NameError)
# ~>    from -:6:in '<module:QuickScript>'
# ~>    from -:5:in '<main>'
