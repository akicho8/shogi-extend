# http://localhost:4000/lab/admin/app-log-search

module QuickScript
  module Admin
    class AppLogSearchScript < Base
      PER_PAGE_LIST = [50, 100, 200, 500, 1000]

      self.title = "アプリログ一覧"
      self.description = "アプリログの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.per_page_default = PER_PAGE_LIST.first
      self.per_page_max = PER_PAGE_LIST.last
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
                :elems   => PER_PAGE_LIST.collect(&:to_s),
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
        shortcut_search_links
      end

      def call
        v_stack do
          [].yield_self do |e|
            e << table_content
          end
        end
      end

      private

      def shortcut_search_links
        links = AppLogSearchKeywordInfo.collect do |e|
          params = { query: [e.key, "-#{self.class.qs_page_key}"].join(" "), __prefer_url_params__: 1 }
          # { _nuxt_link: "#{e.name}", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "px-1 py-1 is-size-6", }
          # https://bulma.io/documentation/elements/button/
          { _nuxt_link: "#{e.name}", _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-light is-small-x", }
        end
        # h_stack(links, :class => "box is-shadowless has-text-weight-bold has-background-white-ter px-3 py-3", :style => "gap:0.5rem")
        # h_stack(links, :class => "has-text-weight-bold", :style => "gap: 0.5rem")
        h_stack(links, :style => "gap: 0.5rem")
      end

      def table_content
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
    end
  end
end
