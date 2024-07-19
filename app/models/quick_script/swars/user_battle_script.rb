module QuickScript
  module Swars
    class UserBattleScript < Base
      self.title = "将棋ウォーズ対局履歴(WIP)"
      self.description = ""
      self.form_method = :get
      self.button_label = "実行"
      self.per_page_default = 1000
      self.router_push_failed_then_fetch = true
      self.button_click_loading = true

      def form_parts
        super + [
          {
            :label           => "将棋ウォーズID",
            :key             => :user_key,
            :type            => :string,
            :default         => params[:user_key].to_s.presence,
            :placeholder     => current_user_key,
          },
        ].yield_self do |e|
          if Rails.env.local?
            e += [
              {
                :label           => "Google スプレッドシートに出力",
                :key             => :google_sheet,
                :type            => :radio_button,
                :elems           => {"しない" => "false", "する" => "true"},
                :default         => "false",
                :hidden_on_query => true,
                :help_message    => "ずっと残しておきたい場合や編集する場合は出力後にエクスポートするか自分のところにコピーしてください",
              },
            ]
          end
          e
        end
      end

      def call
        if current_user_key.blank?
          return
        end
        user = ::Swars::User[current_user_key]
        unless user
          flash[:notice] = "#{current_user_key} は存在しません"
          return
        end

        s = user.memberships.all
        s = s.joins(:battle)
        s = s.includes(:battle => :memberships)
        s = s.includes(:user, :op_user, :location)
        s = s.order(battled_at: :desc)
        s = s.limit(100)

        # rows = scope.collect do |membership|
        #   {}.tap do |row|
        #     row["自分"] = { _nuxt_link: { name: membership.user.key, to: {name: "swars-users-key", params: { key: membership.user.key } }, }, }
        #     row["相手"] = { _nuxt_link: { name: membership.op_user.key, to: {name: "swars-users-key", params: { key: membership.op_user.key } }, }, }
        #     row["勝敗"] = membership.judge.name
        #     row["棋譜"] = { _nuxt_link: { name: membership.battle.key, to: {name: "swars-battles-key", params: { key: membership.battle.key } } } }
        #   end
        # end

        rows = s.collect do |e|
          Rails.logger.tagged(e.battle.key) do
            {}.tap do |row|
              row["自分"] = hyper_link(e.user.key, e.user.key_info.swars_player_url)
              row["相手"] = hyper_link(e.op_user.key, e.op_user.key_info.swars_player_url)
              row["勝敗"] = e.judge.name
              row["先後"] = e.location.name
              row["手数"] = e.battle.turn_max
              row["自分の戦法"] = e.attack_tag_list.join(" → ")
              row["自分の囲い"] = e.defense_tag_list.join(" → ")
              row["相手の戦法"] = e.opponent2.attack_tag_list.join(" → ")
              row["相手の囲い"] = e.opponent2.defense_tag_list.join(" → ")

              # row["棋譜"] = { _nuxt_link: { name: e.battle.key, to: {name: "swars-battles-key", params: { key: e.battle.key } } } }

              # row["名前"] = hyper_link(e.name_with_ban, e.key_info.swars_search_url)
              # row["最高段位"] = e.grade.name
              # row.update(grade_per_rule(e))
              # row["勝率"] = e.cached_stat.total_judge_stat.win_ratio
              # row["勢い"] = e.cached_stat.vitality_stat.level
              # row["行動規範"] = e.cached_stat.gentleman_stat.final_score
              # row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車")
              # row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車")
              # row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              # row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["対局日時"] = e.battle.battled_at.to_fs(:ymdhms)
              row["リンク1"] = hyper_link("棋譜", e.battle.key_info.my_url)
              row["リンク2"] = hyper_link("本家", e.battle.key_info.official_url)
              # row["リンク1"] = hyper_link("棋譜検索(#{e.memberships.size})", e.key_info.swars_search_url)
              # row["リンク2"] = hyper_link("プレイヤー情報", e.key_info.swars_player_url)
              # row["リンク4"] = hyper_link("ググる",         e.key_info.google_search_url)
              # row["最高段位(index)"] = e.grade.pure_info.priority
            end
          end
        end

        if current_google_sheet
          url = GoogleApi::Facade.new(title: "将棋ウォーズ対局履歴", rows: rows, columns_hash: columns_hash).call
          redirect_to url, tab_open: true
        end

        simple_table(rows, always_table: true)
      end

      def current_user_key
        params[:user_key].to_s.strip.presence || user_key_default
      end

      def current_google_sheet
        params[:google_sheet].to_s == "true"
      end

      def user_key_default
        @user_key_default ||= yield_self do
          if Rails.env.local?
            ["BOUYATETSU5", "itoshinTV", "TOBE_CHAN"].sample
          end
        end
      end

      def process_max
        50
      end

      def hyper_link(name, url)
        %(=HYPERLINK("#{url}", "#{name}"))
      end

      def columns_hash
        {
          # "勝率"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          # "居飛車"   => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          # "振り飛車" => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          # "行動規範" => { number_format: { type: "NUMBER",  pattern: "0.000 点",   }, },
          # "直近対局" => { number_format: { type: "DATE",    pattern: "yyyy/MM/dd", }, },
          # "勢い"     => { number_format: { type: "NUMBER",  pattern: "0.00",       }, },
        }
      end
    end
  end
end
