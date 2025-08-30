# frozen-string-literal: true

# http://localhost:4000/lab/general/pre-professional-league-player
# http://localhost:4000/lab/general/pre-professional-league-player?user_name=佐藤天彦
# http://localhost:4000/lab/general/pre-professional-league-player?user_name=今泉健司

module QuickScript
  module General
    class PreProfessionalLeaguePlayerScript < Base
      include PreProfessionalLeagueShared

      self.title = "奨励会三段リーグ個別履歴"
      self.description = "奨励会三段リーグの任意のプレイヤーの情報のみを表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.title_click_behaviour = nil
      self.json_link = true
      self.parent_link = { force_link_to: "/lab/general/pre-professional-league" }

      def form_parts
        super + [
          {
            :label => "",
            :key   => :user_name,
            :type  => :string,
            :dynamic_part => -> {
              {
                :auto_complete_by => :html5,
                :elems            => Ppl::User.order(:name).pluck(:name),
                :default          => params[:user_name].presence,
                :placeholder      => "佐藤天彦",
              }
            },
          },
        ]
      end

      # http://localhost:3000/api/lab/general/pre-professional-league-player.json?json_type=general&user_name=西山朋佳
      def as_general_json
        if target_user
          current_memberships.collect do |membership|
            {
              "年齢" => membership.age,
              "勝率" => membership.ox_win_ratio_to_s,
              "勝数" => membership.win,
              "敗数" => membership.lose,
              "期"   => membership.season.key.name,
              "順位" => membership.ranking_pos,
              "結果" => membership.result.name,
              "勝敗" => membership.ox,
            }
          end
        end
      end

      def call
        if target_user
          rows = current_memberships.collect.with_index(1) do |membership, index|
            {
              "#"    => index,
              "年齢" => membership.age,
              "勝率" => membership.ox_win_ratio_to_s,
              "勝数" => membership.win  || { _v_text: membership.o_count_of_ox, :class => "has-text-grey-lighter" },
              "敗数" => membership.lose || { _v_text: membership.x_count_of_ox, :class => "has-text-grey-lighter" },
              "期"   => { _nuxt_link: membership.season.key.name, _v_bind: { to: qs_nuxt_link_to(qs_page_key: "pre_professional_league", params: { season_key: membership.season.key.name }) }, :class => "", },
              "順位" => membership.ranking_pos,
              ""     => membership.result.pure_info.short_name,
            }
          end
          if rows.none? { it["順位"] }
            rows.each { it.delete("順位") }
          end
          simple_table(rows, always_table: true)
        end
      end

      def target_user
        @target_user ||= Ppl::User[params[:user_name]]
      end

      def current_memberships
        @current_memberships ||= yield_self do
          if target_user
            scope = target_user.memberships
            scope = scope.order(Ppl::Season.arel_table[:position].asc)
            scope = scope.includes(:season, :result)
          end
        end
      end

      ################################################################################

      def title
        @title ||= yield_self do
          if target_user
            [
              target_user.name,
              # "(#{target_user.memberships_first.age}-#{target_user.memberships_last.age})",
              target_user.win_ratio.try { "%.3f" % self },
              # "#{target_user.memberships_first.season.key}-#{target_user.memberships_last.season.key}期",
              target_user.rank.pure_info.short_name,
              # "(#{target_user.mentor.name})",
            ].compact_blank.join(" ")
          else
            super
          end
        end
      end

      ################################################################################ bottom

      def bottom_content
        if target_user
          season_ids = Ppl::Membership.where(user_id: target_user).distinct.pluck(:season_id)
          users = Ppl::User.joins(:memberships).merge(Ppl::Membership.where(season_id: season_ids).distinct)
          users = users.includes(:rank)
          users = users.link_order

          h_stack(:class => "gap_small") do
            users.collect do |e|
              css_klass = [button_css_class, *e.rank.pure_info.nav_css_class]
              { _nuxt_link: e.name, _v_bind: { to: qs_nuxt_link_to(params: { user_name: e.name, __prefer_url_params__: 1 }) }, :class => css_klass.join(" ") }
            end
          end
        end
      end
    end
  end
end
