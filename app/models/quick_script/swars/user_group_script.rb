module QuickScript
  module Swars
    class UserGroupScript < Base
      self.title = "将棋ウォーズ棋力一覧"
      self.description = "指定ユーザーたちの棋力をまとめて表示する (小規模グループ内メンバーの棋力をまとめて把握したいとき用)"
      self.form_method = :get
      self.button_label = "実行"
      self.per_page_default = 1000
      self.router_push_failed_then_fetch = true
      self.button_click_loading = true

      LIMIT_MAX = 50

      def form_parts
        super + [
          {
            :label           => "将棋ウォーズID(s)",
            :key             => :swars_user_keys,
            :type            => :text,
            :default         => params[:swars_user_keys].to_s.presence,
            :placeholder     => default_user_keys,
            :session_sync    => true,
          },
          {
            :label           => "順番",
            :key             => :order_by,
            :type            => :radio_button,
            :elems           => {"grade" => "最高段位", "gentleman" => "行動規範", "vitality" => "勢い", "original" => "そのまま"},
            :default         => params[:order_by].presence || "grade",
            :session_sync    => true,
          },
          {
            :label           => "Google スプレッドシートに出力",
            :key             => :google_sheet,
            :type            => :radio_button,
            :elems           => {"false" => "しない", "true" => "する"},
            :default         => "false",
            :hidden_on_query => true,
            :help_message    => "ずっと残しておきたい場合や編集する場合は出力後にエクスポートするか自分のところにコピってください",
          },
        ]
      end

      def call
        if current_swars_user_keys.blank?
          return
        end

        validate!
        if flash.present?
          return
        end

        AppLog.important(subject: mail_subject, body: mail_body)

        if current_google_sheet
          mail_notify
          redirect_to google_sheet_url, type: :tab_open
          flash[:notice] = "Google スプレッドシートを生成しました。スマホの場合は別タブがブロックされて自動的に開けないはずなので表示された URL をタップしてください。"
          { _v_html: result_html }
        else
          simple_table(rows, always_table: true)
        end
      end

      # 戻値は Array 型になっている場合もある
      def ordered_scope
        @ordered_scope ||= yield_self do
          s = main_scope
          case current_order_by
          when "grade"
            s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc)
          when "original"
            s = s.order([Arel.sql("FIELD(#{::Swars::User.table_name}.user_key, ?)"), current_swars_user_keys])
          when "gentleman"
            s = s.sort_by { |e| -(e.cached_stat.gentleman_stat.final_score || -Float::INFINITY) }
          when "vitality"
            s = s.sort_by { |e| -e.cached_stat.vitality_stat.count }
          end
          s
        end
      end

      def rows
        @rows ||= ordered_scope.collect do |e|
          Rails.logger.tagged(e.key) do
            {}.tap do |row|
              row["名前"] = { _nuxt_link: { name: e.name_with_ban, to: {name: "swars-search", query: { query: e.user_key } }, }, }
              row["最高"] = e.grade.name
              row.update(grade_per_rule(e))
              row["勝率"] = e.cached_stat.total_judge_stat.win_ratio.try { |e| "%.0f %%" % [e * 100] }
              row["勢い"] = e.cached_stat.vitality_stat.level.try { |e| "%.0f %%" % [e * 100] }
              row["規範"] = e.cached_stat.gentleman_stat.final_score.try { "#{floor} 点" }
              row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車").try { |e| "%.0f %%" % [e * 100] }
              row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車").try { |e| "%.0f %%" % [e * 100] }
              row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["直近対局"] = e.latest_battled_at&.to_fs(:ymd)
              if Rails.env.local?
                row["リンク1"] = { _nuxt_link: { name: "棋譜(#{e.memberships.size})", to: {name: "swars-search", query: { query: e.user_key } }, }, }
                row["リンク2"] = { _nuxt_link: { name: "プレイヤー情報", to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
                row["リンク3"] = tag.a("本家", href: e.official_mypage_url, target: "_blank")
                row["リンク4"] = tag.a("ググる", href: e.google_search_url, target: "_blank")
              end
              if Rails.env.local?
                row["最高段位(index)"] = e.grade.pure_info.priority
              end
            end
          end
        end
      end

      def ss_rows
        @ss_rows ||= ordered_scope.collect do |e|
          Rails.logger.tagged(e.key) do
            {}.tap do |row|
              row["名前"]            = hyper_link(e.name_with_ban, e.swars_search_url)
              row["最高段位"]        = e.grade.name
              row.update(grade_per_rule(e))
              row["勝率"]            = e.cached_stat.total_judge_stat.win_ratio
              row["勢い"]            = e.cached_stat.vitality_stat.level
              row["行動規範"]        = e.cached_stat.gentleman_stat.final_score
              row["居飛車"]          = e.cached_stat.tag_stat.use_rate_for(:"居飛車")
              row["振り飛車"]        = e.cached_stat.tag_stat.use_rate_for(:"振り飛車")
              row["主戦法"]          = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
              row["主囲い"]          = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }
              row["直近対局"]        = e.latest_battled_at&.to_fs(:ymd)
              row["リンク1"]         = hyper_link("棋譜検索(#{e.memberships.size})", e.swars_search_url)
              row["リンク2"]         = hyper_link("プレイヤー情報", e.player_info_url)
              row["リンク3"]         = hyper_link("本家",           e.official_mypage_url)
              row["リンク4"]         = hyper_link("ググる",         e.google_search_url)
              row["最高段位(index)"] = e.grade.pure_info.priority
            end
          end
        end
      end

      def google_sheet_url
        @google_sheet_url ||= GoogleApi::Facade.new(title: title, rows: ss_rows, columns_hash: columns_hash).call
      end

      def google_sheet_url_link
        h.tag.a("Google スプレッドシートを開く", href: google_sheet_url, target: "_blank")
      end

      def validate!
        unknown_user_keys = current_swars_user_keys - main_scope.pluck(:key)
        if unknown_user_keys.present?
          flash[:notice] = "#{unknown_user_keys * ' と '} が見つかりません。将棋ウォーズ棋譜検索で一度検索すると出てくるかもしれません。"
          return
        end

        unless main_scope.exists?
          flash[:notice] = "一人も見つかりません"
          return
        end

        if main_scope.count > LIMIT_MAX
          flash[:notice] = "#{LIMIT_MAX} 人以下にしてください"
          return
        end
      end

      def main_scope
        @main_scope ||= yield_self do
          s = ::Swars::User.where(key: current_swars_user_keys)
          s = s.includes(:grade)       # for e.grade.name
          s = s.includes(:memberships) # for e.memberships.size (存在しないのもあるため joins してはいけない)
        end
      end

      def grade_per_rule(user)
        {}.tap do |row|
          user.cached_stat.grade_by_rules_stat.ruleships.each do |e|
            row[e[:rule_info].name] = e[:grade_info].try { name } || ""
          end
        end
      end

      def current_swars_user_keys
        swars_user_keys = params[:swars_user_keys].presence
        if Rails.env.local?
          swars_user_keys ||= default_user_keys
        end
        swars_user_keys.to_s.scan(/\w+/).uniq
      end

      def current_order_by
        (params[:order_by].presence || "original").to_s
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

      def title
        if main_scope.present?
          return "#{super}(#{main_scope.size}人)"
        end
        super
      end

      def columns_hash
        {
          "勝率"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, }, # PERCENT は自動的に100倍してくれる(0.50 → "50 %")
          "勢い"     => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "居飛車"   => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "振り飛車" => { number_format: { type: "PERCENT", pattern: "0 %",        }, },
          "行動規範" => { number_format: { type: "NUMBER",  pattern: "0.000 点",   }, },
          "直近対局" => { number_format: { type: "DATE",    pattern: "yyyy/MM/dd", }, },
        }
      end

      def result_html
        "#{google_sheet_url_link} ← これをタップしてください。編集するなら開いてから右上メニューから「共有とエクスポート」→「コピーを作成」してください。PC の場合は「ファイル」→「コピーを作成」です。"
      end

      def mail_subject
        title
      end

      def mail_body
        {
          "google_sheet_url"        => current_google_sheet ? google_sheet_url : nil,
          "current_swars_user_keys" => current_swars_user_keys,
          **params,
        }.compact_blank.to_t
      end

      # ログインしていてメールアドレスが正しいときのみ念のために送信しておく
      def mail_notify
        if current_user && current_user.email_valid?
          SystemMailer.notify(subject: title, to: current_user.email, bcc: AppConfig[:admin_email], body: google_sheet_url).deliver_later
        end
      end
    end
  end
end

# s = ::Swars::Membership.all
# s = s.joins(:battle => :rule)
# s = s.joins(:user)
# s = s.joins(:grade)
# s = s.merge(main_scope)
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
# s = main_scope
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
