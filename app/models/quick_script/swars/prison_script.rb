module QuickScript
  module Swars
    class PrisonScript < Base
      self.title = "将棋ウォーズ囚人検索"
      self.description = "検察結果を直近順に表示する"
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
              "ID"         => { _link_to: { name: e.user_key, url: e.key_object.mypage_url }, },
              "棋力"       => e.grade.name,
              "収監観測日" => e.ban_at.to_fs(:ymd),
              ""           => { _nuxt_link: { name: "棋譜", to: {name: "swars-search", query: { query: e.user_key, page: 1 } }, }, },
            }
          end
        end
      end

      def pagination_for(scope, &block)
        scope = scope.page(current_page).per(current_per)
        if block
          rows = block.call(scope)
        else
          rows = scope
        end
        {
          :_component   => "QuickScriptShowValueAsTable",
          :paginated    => true,
          :total        => scope.total_count,
          :current_page => scope.current_page,
          :per_page     => current_per,
          :rows         => rows,
        }
      end

      def get_button_show_p
        true
      end

      def button_label
        "検索"
      end

      def current_queries
        params[:query].to_s.scan(/\S+/)
      end
    end
  end
end
