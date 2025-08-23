# http://localhost:4000/lab/admin/app-log-search

module QuickScript
  module Admin
    class AppLogSearchScript < Base
      self.title = "アプリログ"
      self.description = "アプリログの一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"
      self.router_push_failed_then_fetch = true
      self.title_click_behaviour = :force_reload
      self.json_link = true

      def form_parts
        super + [
          {
            :label   => "クエリ",
            :key     => :query,
            :type    => :string,
            :dynamic_part => -> {
              {
                :default => params[:query].presence,
                :help_message => %("a -b c -d" → a と c を含むが b と d は除く),
              }
            },
          },
          {
            :label        => "ログレベル",
            :key          => :log_level_keys,
            :type         => :checkbox_button,
            :dynamic_part => -> {
              {
                :elems   => LogLevelInfo.form_part_elems.to_a.reverse.to_h,
                :default => log_level_keys,
              }
            },
          },
          {
            :label        => "期間",
            :key          => :period_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => PeriodInfo.form_part_elems,
                :default => period_info.key,
              }
            },
          },
          {
            :label   => "1ページあたりの表示件数",
            :key     => :per_page,
            :type    => :radio_button,
            :session_sync => true,
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
        pagination_scope(current_scope)
      end

      def top_content
        blocks = AppLogSearchKeywordInfo.collect { |e|
          av = e.keywords.collect do |word|
            params = { query: "", log_level_keys: "", __prefer_url_params__: 1, page: 1 }
            params[e.param_key] = word
            { _nuxt_link: word, _v_bind: { to: qs_nuxt_link_to(params: params) }, :class => "button is-small #{e.css_klass}" }
          end
          av = h_stack(av, :class => "gap_small")
          v_stack([tag.span(e.name, :class => "is-size-7"), av], :class => "gap_small")
        }
        v_stack(blocks, :class => "gap_small")
      end

      def call
        pagination_for(current_scope, always_table: true) do |scope|
          scope.collect do |e|
            {
              "ID"   => { _nuxt_link: e.id, _v_bind: { to: qs_nuxt_link_to(qs_page_key: "app_log_show", params: { id: e.id }), } },
              "日時" => e.created_at.to_fs(:ymdhms),
              "LV"   => e.level,
              "絵"   => e.emoji,
              "題"   => e.subject,
              "本文" => { _autolink: e.body },
            }
          end
        end
      end

      def current_scope
        scope = AppLog.plus_minus_search(params[:query])
        if v = log_level_keys.presence
          scope = scope.level_eq(v)
        end
        scope = scope.public_send(period_info.key)
      end

      def log_level_keys
        params[:log_level_keys].to_s.scan(/\w+/)
      end

      def title
        @title ||= "#{super} (#{current_scope.count})"
      end

      ################################################################################

      def per_page_list
        [50, 100, 200, 500, 1000]
      end

      def per_page_default
        per_page_list.first
      end

      def per_page_max
        per_page_list.last
      end

      ################################################################################

      def period_key
        PeriodInfo.lookup_key_or_first(params[:period_key])
      end

      def period_info
        PeriodInfo.fetch(period_key)
      end

      ################################################################################
    end
  end
end
