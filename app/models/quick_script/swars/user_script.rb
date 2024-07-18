module QuickScript
  module Swars
    class UserScript < Base
      self.title = "将棋ウォーズ棋力一覧"
      self.description = "指定ユーザー毎の棋力をまとめて表示する (SNSグループのメンバー全員の棋力を把握したいときなどにどうぞ)"
      self.form_method = :get
      self.button_label = "実行"
      self.per_page_default = 1000
      self.router_push_failed_then_fetch = true
      self.button_click_loading = true

      def form_parts
        super + [
          {
            :label           => "将棋ウォーズID(s)",
            :key             => :user_keys,
            :type            => :text,
            :default         => params[:user_keys].to_s.presence,
            :placeholder     => default_user_keys,
          },
          {
            :label           => "順番",
            :key             => :order_by,
            :type            => :radio_button,
            :elems           => {"最高段位" => "grade", "行動規範" => "gentleman", "勢い" => "vitality", "そのまま" => "original"},
            :default         => params[:order_by].presence || "grade",
          },
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

      def call
        # return params

        if current_user_keys.blank?
          return
        end

        user_scope = ::Swars::User.where(key: current_user_keys)

        if true
          if true
            unknown_user_keys = current_user_keys - user_scope.pluck(:key)
            if unknown_user_keys.present?
              return "#{unknown_user_keys * ' と '} が見つかりません。将棋ウォーズ棋譜検索で一度検索すると出てくるかもしれません。"
            end
          end

          unless user_scope.exists?
            return "一人も見つかりません"
          end

          if user_scope.count > process_max
            return "#{process_max} 人以下にしてください"
          end
        end

        # s = ::Swars::Membership.all
        # s = s.joins(:battle => :rule)
        # s = s.joins(:user)
        # s = s.joins(:grade)
        # s = s.merge(user_scope)
        # s = s.group("swars_users.user_key")
        # s = s.group("rule_key")
        # s = s.joins("JOIN swars_grades g ON g.id = swars_users.grade_id") if false # 最高棋力をついでに求める
        # s = s.select("swars_users.user_key")                                       # ウォーズID
        # s = s.select("#{::Swars::Rule.table_name}.key AS rule_key")                # ルール
        # s = s.select("MIN(#{::Swars::Grade.table_name}.priority) AS min_priority") # ルール別の最高棋力
        # s = s.select("g.key AS max_grade_key") if false                            # 最高棋力
        #
        # # >> |-------------+-----------+--------------+
        # # >> | user_key    | rule_key  | min_priority |
        # # >> |-------------+-----------+--------------+
        # # >> | BOUYATETSU5 | ten_min   |            4 |
        # # >> | BOUYATETSU5 | ten_sec   |            4 |
        # # >> | BOUYATETSU5 | three_min |            5 |
        # # >> | TOBE_CHAN   | ten_min   |            5 |
        # # >> | TOBE_CHAN   | ten_sec   |           38 |
        # # >> | itoshinTV   | ten_sec   |            4 |
        # # >> | itoshinTV   | ten_min   |            5 |
        # # >> | itoshinTV   | three_min |            3 |
        # # >> |-------------+-----------+--------------+
        #
        # if false
        #   # SQL を使って min_priority を棋力名に変換する
        #   sql = <<~SQL
        #   SELECT
        #      dispatcher.user_key,
        #      dispatcher.rule_key,
        #      g.key as grade_key
        #   FROM (#{s.to_sql}) dispatcher
        #   JOIN swars_grades g ON g.priority = dispatcher.min_priority
        # SQL
        #   hv = ActiveRecord::Base.connection.select_all(sql).each_with_object({}) do |e, m|
        #     e = e.symbolize_keys
        #     m[e[:user_key]] ||= {}
        #     m[e[:user_key]][e[:rule_key].to_sym] = e[:grade_key]
        #   end
        # else
        #   # SQL を使わずに棋力名に変換する
        #   hv = s.each_with_object({}) do |e, m|
        #     m[e.user_key] ||= {}
        #     m[e.user_key][e.rule_key.to_sym] = ::Swars::GradeInfo.fetch(e.min_priority).name
        #   end
        # end
        #
        # s = user_scope
        # s = s.includes(:grade)
        # rows = s.collect do |e|
        #   row = {}
        #   row["名前"] = { _nuxt_link: { name: e.key, to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
        #   row["最高"] = e.grade.name
        #   ::Swars::RuleInfo.each do |rule_info|
        #     row[rule_info.name] = hv.dig(e.user_key, rule_info.key) || "?"
        #   end
        #   row["index"] = e.grade.pure_info.priority
        #   row
        # end

        s = user_scope
        s = s.includes(:grade)       # for e.grade.name
        s = s.includes(:memberships) # for e.memberships.size (存在しないのもあるため joins してはいけない)

        case current_order_by
        when "grade"
          s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc)
        when "original"
          s = s.order([Arel.sql("FIELD(#{::Swars::User.table_name}.user_key, ?)"), current_user_keys])
        when "gentleman"
          s = s.sort_by { |e| -(e.cached_stat.gentleman_stat.final_score || -Float::INFINITY) }
        when "vitality"
          s = s.sort_by { |e| -e.cached_stat.vitality_stat.level }
        end

        if fetch_index >= 1 || true
          if current_google_sheet
            rows = s.collect do |e|
              Rails.logger.tagged(e.key) do
                {}.tap do |row|
                  row["名前"] = hyper_link(e.name_with_ban, e.key_info.swars_search_url)
                  row["最高段位"] = e.grade.name
                  row.update(grade_per_rule(e))
                  row["勝率"] = e.cached_stat.total_judge_stat.win_ratio
                  row["勢い"] = e.cached_stat.vitality_stat.level
                  row["行動規範"] = e.cached_stat.gentleman_stat.final_score
                  row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車")
                  row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車")
                  row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
                  row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
                  row["直近対局"] = e.latest_battled_at&.to_fs(:ymd)
                  row["リンク1"] = hyper_link("棋譜検索(#{e.memberships.size})", e.key_info.swars_search_url)
                  row["リンク2"] = hyper_link("プレイヤー情報", e.key_info.swars_player_url)
                  row["リンク3"] = hyper_link("本家",           e.key_info.my_page_url)
                  row["リンク4"] = hyper_link("ググる",         e.key_info.google_search_url)
                  row["最高段位(index)"] = e.grade.pure_info.priority
                end
              end
            end

            url = GoogleApi::Facade.new(title: "将棋ウォーズ棋力一覧", rows: rows, columns_hash: columns_hash).call
            redirect_to url, tab_open: true
          end
        end

        rows = s.collect do |e|
          Rails.logger.tagged(e.key) do
            {}.tap do |row|
              row["名前"] = { _nuxt_link: { name: e.name_with_ban, to: {name: "swars-search", query: { query: e.user_key } }, }, }
              row["最高"] = e.grade.name
              row.update(grade_per_rule(e))
              row["勝率"] = e.cached_stat.total_judge_stat.win_ratio.try { |e| "%.0f %%" % [e * 100] }
              row["勢い"] = e.cached_stat.vitality_stat.level.try { |e| "%.2f" % e }
              row["規範"] = e.cached_stat.gentleman_stat.final_score.try { "#{floor} 点" }
              row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車").try { |e| "%.0f %%" % [e * 100] }
              row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車").try { |e| "%.0f %%" % [e * 100] }
              row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["直近対局"] = e.latest_battled_at&.to_fs(:ymd)
              if Rails.env.local?
                row["リンク1"] = { _nuxt_link: { name: "棋譜(#{e.memberships.size})", to: {name: "swars-search", query: { query: e.user_key } }, }, }
                row["リンク2"] = { _nuxt_link: { name: "プレイヤー情報", to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
                row["リンク3"] = tag.a("本家", href: e.key_info.my_page_url, target: "_blank")
                row["リンク4"] = tag.a("ググる", href: e.key_info.google_search_url, target: "_blank")
              end
              if Rails.env.local?
                row["最高段位(index)"] = e.grade.pure_info.priority
              end
            end
          end
        end

        simple_table(rows, always_table: true)
      end

      def grade_per_rule(user)
        row = {}
        user.cached_stat.grade_by_rules_stat.ruleships.each do |e|
          row[e[:rule_info].name] = e[:grade_info].try { name } || ""
        end
        row
      end

      def current_user_keys
        user_keys = params[:user_keys].presence
        if Rails.env.local?
          user_keys ||= default_user_keys
        end
        user_keys.to_s.scan(/\w+/).uniq
      end

      def current_order_by
        params[:order_by].presence || "original"
      end

      def current_google_sheet
        params[:google_sheet].to_s == "true"
      end

      def default_user_keys
        @default_user_keys ||= yield_self do
          av = nil
          # av ||= ::Swars::User::Vip.auto_crawl_user_keys
          av ||= ["BOUYATETSU5", "itoshinTV", "TOBE_CHAN"]
          av ||= []
          av.shuffle * " "
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
          "勝率"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "居飛車"   => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "振り飛車" => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "行動規範" => { number_format: { type: "NUMBER",  pattern: "0.000 点",   }, },
          "直近対局" => { number_format: { type: "DATE",    pattern: "yyyy/MM/dd", }, },
          "勢い"     => { number_format: { type: "NUMBER",  pattern: "0.00",       }, },
        }
      end
    end
  end
end
