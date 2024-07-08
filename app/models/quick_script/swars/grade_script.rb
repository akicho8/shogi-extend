module QuickScript
  module Swars
    class GradeScript < Base
      self.title = "将棋ウォーズ棋力一覧"
      self.description = "指定ユーザー毎の棋力をまとめて表示する (LINEグループのメンバー全員の棋力を把握したいときなどにどうぞ)"
      self.form_method = :get
      self.button_label = "実行"
      self.per_page_default = 1000

      if Rails.env.local? && false
        INPUT_DEFAULT = ::Swars::User::Vip.auto_crawl_user_keys.join(" ")
      else
        INPUT_DEFAULT = ["BOUYATETSU5", "itoshinTV", "TOBE_CHAN"].shuffle * " "
      end

      def form_parts
        super + [
          {
            :label          => "将棋ウォーズID(s)",
            :key            => :user_keys,
            :type           => :string,
            :default        => params[:user_keys].to_s.presence,
            :placeholder    => INPUT_DEFAULT,
            # :bottom_message => "ウォーズIDを複数入力してください",
          },
        ]
      end

      def call
        user_scope = ::Swars::User.where(key: current_user_keys)
        user_scope = user_scope.order([Arel.sql("FIELD(#{::Swars::User.table_name}.user_key, ?)"), current_user_keys])

        unknown_user_keys = current_user_keys - user_scope.pluck(:key)
        if unknown_user_keys.present?
          return "#{unknown_user_keys * ' と '} が見つかりません。将棋ウォーズ棋譜検索で一度検索すると出てくるかもしれません。"
        end
        unless user_scope.exists?
          return "一人も見つかりません"
        end

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
        # s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc)
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

        simple_table(rows, header_hide: false)
      end

      def current_user_keys
        (params[:user_keys] || INPUT_DEFAULT).to_s.scan(/\w+/).uniq
      end
    end
  end
end
