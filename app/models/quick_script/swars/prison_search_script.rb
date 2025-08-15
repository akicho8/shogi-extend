module QuickScript
  module Swars
    class PrisonSearchScript < Base
      self.title = "将棋ウォーズ囚人検索"
      self.description = "囚人を収監発見日の直近順に表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 100
      self.json_link = true

      def form_parts
        super + [
          {
            :label   => "部分一致文字列",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].to_s,
              }
            },
          },
        ]
      end

      def call
        AppLog.info(subject: "[囚人][検索] #{current_queries}")
        pagination_for(current_scope, always_table: false) do |scope|
          scope.collect do |e|
            {
              "ウォーズID" => { _link_to: e.key, _v_bind: { href: e.official_mypage_url }, },
              "段級位"     => e.grade.name,
              "発見"       => e.ban_at.to_fs(:ymd),
              ""           => { _nuxt_link: "棋譜(#{e.memberships.size})", _v_bind: { to: { name: "swars-search", query: { query: e.user_key, page: 1 } }, }, },
            }
          end
        end
      end

      def as_general_json
        pagination_scope(current_scope).collect do |e|
          {
            "ウォーズID" => e.key,
            "段級位"     => e.grade.name,
            "発見日時"   => e.ban_at,
          }
        end
      end

      def current_scope
        scope = ::Swars::User.all
        scope = scope.ban_only
        scope = scope.order(ban_at: :desc)
        scope = scope.joins(:grade)          # 1:1 なので join でよい。条件に含まれるため必要。
        scope = scope.includes(:grade)       # for e.grade.name
        scope = scope.includes(:memberships) # for e.memberships.size (存在しないのもあるため joins してはいけない)
        current_queries.each do |query|
          sanitized_query = ActiveRecord::Base.sanitize_sql_like(query.downcase)
          c1 = ::Swars::User.where("LOWER(#{::Swars::User.table_name}.user_key) LIKE ?", "%#{sanitized_query}%")
          c2 = ::Swars::Grade.unscoped.where("#{::Swars::Grade.table_name}.key LIKE ?", "%#{sanitized_query}%")
          scope = scope.and(c1.or(c2))
        end
        scope
      end

      def current_queries
        params[:query].to_s.scan(/\S+/)
      end
    end
  end
end
