module QuickScript
  module Dev
    class UserSearchScript < Base
      self.title = "ユーザー検索"
      self.description = "検察結果を直近順に表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 5

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
        scope = User.all
        # current_queries.each do |query|
        #   query = MysqlToolkit.escape_for_like(query.downcase)
        #   c1 = ::Swars::User.where(["LOWER(user_key) LIKE ?", "%#{query}%"])
        #   scope = scope.and(c1.or(c2))
        # end
        pagination_for(scope) do |scope|
          scope.collect do |e|
            {
              "ID"         => e.id,
              "name"       => e.name,
              # "棋力"       => e.grade.name,
              # "収監観測日" => e.ban_at.to_fs(:ymd),
              # ""           => { _nuxt_link: { name: "棋譜", to: {name: "swars-search", query: { query: e.user_key, page: 1 } }, }, },
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
