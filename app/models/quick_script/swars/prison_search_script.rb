module QuickScript
  module Swars
    class PrisonSearchScript < Base
      self.title = "将棋ウォーズ囚人検索"
      self.description = "囚人を収監発見日の直近順に表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 500

      def form_parts
        super + [
          {
            :label   => "部分一致文字列",
            :key     => :query,
            :type    => :string,
            :default => params[:query].to_s,
          },
        ]
      end

      def call
        scope = ::Swars::User.all
        scope = scope.ban_only
        scope = scope.order(ban_at: :desc)
        scope = scope.joins(:grade)          # 1:1 なので join でよい。条件に含まれるため必要。
        scope = scope.includes(:grade)       # for e.grade.name
        scope = scope.includes(:memberships) # for e.memberships.size (存在しないのもあるため joins してはいけない)
        current_queries.each do |query|
          sanitized_query = ActiveRecord::Base.sanitize_sql_like(query.downcase)
          c1 = ::Swars::User.where("LOWER(swars_users.user_key) LIKE ?", "%#{sanitized_query}%")
          c2 = ::Swars::Grade.unscoped.where("`swars_grades`.`key` LIKE ?", "%#{sanitized_query}%")
          scope = scope.and(c1.or(c2))
        end
        pagination_for(scope, always_table: false) do |scope|
          scope.collect do |e|
            {
              "名前" => { _link_to: { name: e.key, url: e.key_info.my_page_url }, },
              "段位" => e.grade.name,
              "発見" => e.ban_at.to_fs(:ymd),
              ""     => { _nuxt_link: { name: "棋譜(#{e.memberships.size})", to: {name: "swars-search", query: { query: e.user_key, page: 1 } }, }, },
            }
          end
        end
      end

      def current_queries
        params[:query].to_s.scan(/\S+/)
      end
    end
  end
end
