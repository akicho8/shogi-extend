module QuickScript
  module Swars
    class UserScript < Base
      self.title = "将棋ウォーズ棋力一覧"
      self.description = "指定ユーザー毎の棋力をまとめて表示する (SNSグループのメンバー全員の棋力を把握したいときなどにどうぞ)"
      self.form_method = :get
      self.button_label = "実行"
      self.per_page_default = 1000

      def form_parts
        super + [
          {
            :label       => "将棋ウォーズID(s)",
            :key         => :user_keys,
            :type        => :text,
            :default     => params[:user_keys].to_s.presence,
            :placeholder => default_user_keys,
          },
          {
            :label       => "順番",
            :key         => :order_by,
            :type        => :radio_button,
            :elems       => {"そのまま" => "original", "最高段位" => "grade", "行動規範" => "gentleman"},
            :default     => params[:order_by].presence || "original",
          },
        ]
      end

      def call
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

        if false
          s = ::Swars::Membership.all
          s = s.joins(:battle => :rule)
          s = s.joins(:user)
          s = s.joins(:grade)
          s = s.merge(user_scope)
          s = s.group("swars_users.user_key")
          s = s.group("rule_key")
          s = s.joins("JOIN swars_grades g ON g.id = swars_users.grade_id") if false # 最高棋力をついでに求める
          s = s.select("swars_users.user_key")                                       # ウォーズID
          s = s.select("#{::Swars::Rule.table_name}.key AS rule_key")                # ルール
          s = s.select("MIN(#{::Swars::Grade.table_name}.priority) AS min_priority") # ルール別の最高棋力
          s = s.select("g.key AS max_grade_key") if false                            # 最高棋力

          # >> |-------------+-----------+--------------+
          # >> | user_key    | rule_key  | min_priority |
          # >> |-------------+-----------+--------------+
          # >> | BOUYATETSU5 | ten_min   |            4 |
          # >> | BOUYATETSU5 | ten_sec   |            4 |
          # >> | BOUYATETSU5 | three_min |            5 |
          # >> | TOBE_CHAN   | ten_min   |            5 |
          # >> | TOBE_CHAN   | ten_sec   |           38 |
          # >> | itoshinTV   | ten_sec   |            4 |
          # >> | itoshinTV   | ten_min   |            5 |
          # >> | itoshinTV   | three_min |            3 |
          # >> |-------------+-----------+--------------+

          if false
            # SQL を使って min_priority を棋力名に変換する
            sql = <<~SQL
          SELECT
             main.user_key,
             main.rule_key,
             g.key as grade_key
          FROM (#{s.to_sql}) main
          JOIN swars_grades g ON g.priority = main.min_priority
        SQL
            hv = ActiveRecord::Base.connection.select_all(sql).each_with_object({}) do |e, m|
              e = e.symbolize_keys
              m[e[:user_key]] ||= {}
              m[e[:user_key]][e[:rule_key].to_sym] = e[:grade_key]
            end
          else
            # SQL を使わずに棋力名に変換する
            hv = s.each_with_object({}) do |e, m|
              m[e.user_key] ||= {}
              m[e.user_key][e.rule_key.to_sym] = ::Swars::GradeInfo.fetch(e.min_priority).name
            end
          end

          s = user_scope
          s = s.includes(:grade)
          rows = s.collect do |e|
            row = {}
            row["名前"] = { _nuxt_link: { name: e.key, to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
            row["最高"] = e.grade.name
            ::Swars::RuleInfo.each do |rule_info|
              row[rule_info.name] = hv.dig(e.user_key, rule_info.key) || "?"
            end
            row["index"] = e.grade.pure_info.priority
            row
          end
        else
          s = user_scope
          s = s.includes(:grade)

          case current_order_by
          when "grade"
            s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc)
          when "original"
            s = s.order([Arel.sql("FIELD(#{::Swars::User.table_name}.user_key, ?)"), current_user_keys])
          when "gentleman"
            s = s.sort_by { |e| -(e.cached_stat.gentleman_stat.final_score || -Float::INFINITY) }
          end

          rows = s.collect do |e|
            Rails.logger.tagged(e.key) do
              {}.tap do |row|
                row["名前"] = { _nuxt_link: { name: e.key, to: {name: "swars-search", query: { query: e.user_key } }, }, }

                if Rails.env.local?
                  row["情報"] = { _nuxt_link: { name: e.key, to: {name: "swars-users-key", params: { key: e.user_key } }, }, }
                end

                row["最高"] = e.grade.name
                e.cached_stat.grade_by_rules_stat.ruleships.each do |e|
                  row[e[:rule_info].name] = e[:grade_info].try { name } || ""
                end

                row["勝率"] = e.cached_stat.total_judge_stat.win_ratio.try { |e| "%.0f %%" % [e * 100] }

                row["規範"] = e.cached_stat.gentleman_stat.final_score.try { "#{floor} 点" }

                row["居飛車"]   = e.cached_stat.tag_stat.use_rate_for(:"居飛車").try { |e| "%.0f %%" % [e * 100] }
                row["振り飛車"] = e.cached_stat.tag_stat.use_rate_for(:"振り飛車").try { |e| "%.0f %%" % [e * 100] }

                row["主戦法"] = e.cached_stat.simple_matrix_stat.my_attack_tag.try { name }
                row["主囲い"] = e.cached_stat.simple_matrix_stat.my_defense_tag.try { name }

                row["直近対局"] = e.latest_battled_at&.to_fs(:ymd)

                if Rails.env.local?
                  row["最高段位(index)"] = e.grade.pure_info.priority
                end
              end
            end
          end
        end

        simple_table(rows, always_table: true)
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

      def default_user_keys
        @default_user_keys ||= yield_self do
          av = nil
          # av ||= ::Swars::User::Vip.auto_crawl_user_keys
          av ||= ["BOUYATETSU5", "itoshinTV", "TOBE_CHAN"]
          av.shuffle * " "
        end
      end

      def process_max
        50
      end
    end
  end
end
