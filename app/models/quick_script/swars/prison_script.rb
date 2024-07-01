module QuickScript
  module Swars
    class PrisonScript < Base
      self.title = "将棋ウォーズ囚人検索"
      self.per_page_default = 1000

      # ~/src/shogi-extend/nuxt_side/components/QuickScript/QuickScriptShow.vue
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
        scope = ::Swars::User.ban_only.order(ban_at: :desc)
        if query = current_query
          query = MysqlToolkit.escape_for_like(query.downcase)
          scope = scope.where(["LOWER(user_key) LIKE ?", "%#{query}%"])
        end
        scope = with_paginate(scope)
        scope.collect do |e|
          {
            "ID"         => e.user_key,
            "棋力"       => e.grade.name,
            "収監観測日" => e.ban_at.to_fs(:ymd),
            # "最終対局日" => e.latest_battled_at&.to_fs(:ymd),
            # **e.attributes,
          }
        end
      end

      def get_button_show_p
        true
      end

      def button_label
        "検索"
      end

      def current_query
        params[:query].presence
      end
    end
  end
end
