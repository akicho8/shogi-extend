module QuickScript
  module Swars
    class PrisonSearchScript < Base
      self.title = "将棋ウォーズ囚人検索"
      self.description = "検察結果を直近順に表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 1000

      def form_parts
        super + [
          {
            :label   => "検索文字列",
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
        scope = scope.joins(:grade)
        current_queries.each do |query|
          query = MysqlToolkit.escape_for_like(query.downcase)
          c1 = ::Swars::User.where(["LOWER(user_key) LIKE ?", "%#{query}%"])
          c2 = ::Swars::User.where(::Swars::Grade.arel_table[:key].eq(query))
          scope = scope.and(c1.or(c2))
        end
        pagination_for(scope) do |scope|
          scope.collect do |e|
            {
              "ID"         => { _link_to: { name: e.user_key, url: e.key_object.my_page_url }, },
              "棋力"       => e.grade.name,
              "収監観測日" => e.ban_at.to_fs(:ymd),
              ""           => { _nuxt_link: { name: "棋譜", to: {name: "swars-search", query: { query: e.user_key, page: 1 } }, }, },
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
