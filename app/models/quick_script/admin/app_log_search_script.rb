# http://localhost:4000/lab/admin/app-log-search

module QuickScript
  module Admin
    class AppLogSearchScript < Base
      self.title = "アプリログ一覧"
      self.description = "アプリログの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.router_push_failed_then_fetch = true
      self.title_link = :force_reload
      self.json_link = true

      if Rails.env.development? && false
        def header_link_items
          super + AppLogSearchKeywordInfo.collect do |e|
            params = { query: [e.key, "-#{self.class.qs_page_key}"].join(" "), __prefer_url_params__: 1 }
            { name: e.name, _v_bind: { tag: "nuxt-link", to: qs_nuxt_link_to(params: params), :class => "", }, }
          end
        end
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
                :help_message => %("a -b c -d" → a と c を含むかつ b と d を含まない),
              }
            },
          },
          {
            :label   => "抽出件数（直近N件）",
            :key     => :per_page,
            :type    => :radio_button,
            :dynamic_part => -> {
              {
                :elems   => per_page_list.collect(&:to_s),
                :default => current_per.to_s,
              }
            },
          },
        ]
      end

      def as_general_json
        pagination_scope(AppLog.plus_minus_search(params[:query]))
      end

      def head_content
        links = AppLogSearchKeywordInfo.collect do |e|
          params = { query: [e.key, "-#{self.class.qs_page_key}"].join(" "), __prefer_url_params__: 1 }
          { _nuxt_link: "#{e.name}", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-light is-small-x" }
        end
        h_stack(links, :style => "gap: 0.5rem")
      end

      def call
        pagination_for(AppLog.plus_minus_search(params[:query]), always_table: true) do |scope|
          scope.collect do |e|
            {
              "ID"   => { _nuxt_link: e.id, _v_bind: { to: qs_nuxt_link_to(params: {id: e.id}), } },
              "日時" => e.created_at.to_fs(:ymdhms),
              "LV"   => e.level,
              "絵"   => e.emoji,
              "題"   => e.subject,
              "本文" => { _autolink: e.body },
            }
          end
        end
      end

      def per_page_list
        [50, 100, 200, 500, 1000]
      end

      def per_page_default
        per_page_list.first
      end

      def per_page_max
        per_page_list.last
      end
    end
  end
end
