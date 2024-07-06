module QuickScript
  module Swars
    class GradeScript < Base
      self.title = "横断"
      self.description = "検察結果を直近順に表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 1000

      if Rails.env.local?
        SAMPLE = ::Swars::User::Vip.auto_crawl_user_keys.join(" ")
      else
        SAMPLE = "BOUYATETSU5 itoshinTV pagagm"
      end

      def form_parts
        super + [
          {
            :label          => "将棋ウォーズID(s)",
            :key            => :swars_user_keys,
            :type           => :string,
            :default        => params[:swars_user_keys].to_s.presence,
            :placeholder    => SAMPLE,
            :bottom_message => "ウォーズIDを複数入力してください",
          },
        ]
      end

      def call
        user_scope = ::Swars::User.where(key: current_swars_user_keys)
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

        # min_priority を棋力名に変換する
        tp s
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

        s = user_scope
        s = s.joins(:grade).order(::Swars::Grade.arel_table[:priority].asc) if true
        s = s.includes(:grade)
        rows = s.collect do |e|
          row = {}
          row["ID"]   = { _link_to: { name: e.user_key, url: e.key_object.my_page_url }, }
          row["最高"] = e.grade.name
          ::Swars::RuleInfo.each do |rule_info|
            row[rule_info.name] = hv.dig(e.user_key, rule_info.key) || "?"
          end
          row[""] = { _nuxt_link: { name: "棋譜", to: {name: "swars-search", query: { query: e.user_key, page: 1 } }, }, }
          row
        end
        {
          :_component   => "QuickScriptViewValueAsTable",
          :rows         => rows,
          :always_table => true,
        }
      end

      def current_swars_user_keys
        (params[:swars_user_keys] || SAMPLE).to_s.scan(/\w+/)
      end
    end
  end
end
