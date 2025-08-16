# frozen-string-literal: true

# http://localhost:4000/lab/general/pre-professional-league

module QuickScript
  module General
    class PreProfessionalLeagueScript < Base
      self.title = "奨励会三段リーグ成績早見表"
      self.description = "奨励会三段リーグの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = :force_reload
      self.json_link = true

      def header_link_items
        super + [
          { name: "推移図", icon: "chart-box", _v_bind: { href: "/lab/general/pre-professional-league.html", target: "_self", }, },
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
            :key     => :season_number,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:season_number].presence,
                :placeholder => "58 59 60",
                :help_message => %(例: "58 59 60" → 58〜60期のどこかに在籍していたメンバーで絞る)
              }
            },
          },
          {
            :label   => "この棋士の同期 (完全一致・複数指定はOR条件)",
            :key     => :name,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:name].presence,
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
                :help_message => %(例: "井上 森信" → "井上か森信の門下で絞る ※連盟の表記にばらつきがあるため正確ではないる結果になる場合がある)
              }
            },
          },
        ]
      end

      # http://localhost:3000/api/lab/general/pre-professional-league.json?json_type=general
      def as_general_json
        if false
          # このネストした形式は R の前処理がややこしくなりすぎて自分にはさっぱりわからん
          current_scope.collect do |user|
            {
              "弟子"         => user.name,
              "師匠"         => user.mentor.name,
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
        else
          # R にやさしいハッシュの配列にする
          current_scope.unscope(:order).json_order.flat_map do |user|
            user.memberships.collect do |membership|
              {
                "名前" => membership.user.name,
                "勝数" => membership.win,
                "結果" => membership.result.name,
                "期次" => membership.league_season.season_number,
              }
            end
          end
        end
      end

      def call
        params[:season_number] ||= Ppl::LeagueSeason.season_number_max

        rows = current_scope.collect do |user|
          {
            "弟子" => { _nuxt_link: user.name, _v_bind: { to: qs_nuxt_link_to(params: default_params.merge(name: user.name)) }, :class => css_class(user) },
            "師匠" => user_mentor_name(user),
            "期間" => user.memberships_count,
            "齢〜" => user.age_min,
            "〜齢" => user.age_max,
            "次点" => user.runner_up_count,
            "最勝" => user.win_max,
            "昇齢" => user.promotion_age,
            "昇期" => user.promotion_season_number,
            "昇勝" => user.promotion_win,
            **memberhip_fields(user),
          }
        end
        simple_table(rows)
      end

      def user_mentor_name(user)
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

      def css_class(user)
        av = ["is_decoration_off"]
        if user.promoted_or_rights
          av << "has-text-weight-bold"
        end
        av
      end

      ################################################################################

      def title
        @title ||= "#{super} (#{current_scope.count})"
      end

      ################################################################################

      def top_content
        v_stack([league_season_links, user_links, mentor_links], :class => "gap_small")
      end

      def league_season_links
        h_stack(:class => "gap_small") do
          blocks = Ppl::LeagueSeason.newest_order.collect do |e|
            params = default_params.merge(season_number: e.season_number)
            { _nuxt_link: e.season_number, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => button_css_class.join(" ") }
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
            params = default_params.merge(name: e.name)
            css_klass = button_css_class
            if e.promoted_or_rights
              css_klass += ["has-text-weight-bold"]
            end
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
        { name: "", season_number: "", mentor_name: "", query: "", __prefer_url_params__: 1 }
      end

      ################################################################################
    end
  end
end
