module QuickScript
  module Admin
    class AppLogSearchScript < Base
      self.title = "アプリログ一覧"
      self.description = "アプリログの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = 200
      self.router_push_failed_then_fetch = true
      self.title_link = :force_reload

      def header_link_items
        super + query_keywords.collect do |e|
          query = { query: [e, "-#{self.class.qs_page_key}"].join(" "), __prefer_url_params__: 1 }
          { name: e, _v_bind: { tag: "nuxt-link", to: { path: %(/lab/admin/app_log_search?#{query.to_query}) }, :class => "", }, }
        end
      end

      def query_keywords
        [
          "共有将棋盤",
          "チャット",
          "オーダー配布",
          "cc_behavior_start",
          "cc_behavior_silent_stop",
          "KENTO API",
          "ぴよ将棋",
          "短縮URL作成",
          "短縮URLリダイレクト",
          "ウォーズID不明",
          "囚人",
          "棋譜コピー",
          "ぴよ将棋起動",
          "KENTO起動",
        ]
      end

      def form_parts
        super + [
          {
            :label   => "クエリ",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].presence,
                :help_message => "a -b c -d で、a と c を含むかつ b と d を含まない",
              }
            },
          },
        ]
      end

      def call
        pagination_for(AppLog.search2(params[:query]), always_table: true) do |scope|
          scope.collect do |e|
            {
              "ID"   => { _nuxt_link: e.id, _v_bind: { to: { name: "lab-qs_group_key-qs_page_key", params: { qs_group_key: "admin", qs_page_key: "app_log_show" }, query: { id: e.id }, }, }, :class => "", },
              "日時" => e.created_at.to_fs(:ymdhms),
              "LV"   => e.level,
              "絵"   => e.emoji,
              "題"   => e.subject,
              "本文" => { _autolink: e.body },
            }
          end
        end
      end
    end
  end
end
