# 組み込みスクリプトの本体
#
# ▼POSTタイプのときにsubmitする前の段階で何か実行させるには？
#
#   def show_action
#     unless target_record.group_info
#       c.redirect_to(script_link_path(:id => :dynamic_page_group_script))
#     end
#     super
#   end
#
# ▼script_bodyの中から他のクラスに委譲するには？
#
#   DynamicPageGroupScript.new(:current_user => current_user, :view_context => view_context, :controller => controller).script_body
#   または
#   DynamicPageGroupScript.new(@org_params).script_body
#
# ▼post後に別のところにリダイレクトするには？
#
#   def post_redirect_path(redirect_params)
#     script_link_path(:id => :oshirase_search_script)
#   end
#
module FrontScript
  class Base < MyScript::Soul
    def self.url_prefix
      [:front_script]
    end

    def create_or_update_action
      # code = run_and_result_cache_write # ここで実行している

      _ret = script_body_run

      # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
      if c.performed?
        return
      end

      if true
        # エラーだったらリダイレクトせずに描画する
        if _ret[:alert_message]
          c.render :text => response_render(Response[_ret]), :layout => true
          return
        end
      end

      as_rails_cache_store_key = SecureRandom.hex
      # POST で User.all.to_a などを返すと AR の配列が Marshal.dump されて undefined class/module な現象が起きる。
      # これはmemcachedへのMarshalの不具合。
      #
      # undefined class/module とか言われてアプリの起動ができなくなってしまう
      # http://xibbar.hatenablog.com/entry/20130221/1361556846
      #
      Rails.cache.write(as_rails_cache_store_key, _ret, :expires_in => 3.minutes)

      redirect_params = clean_params
      redirect_params.update(:as_rails_cache_store_key => as_rails_cache_store_key)
      # _resp = Rails.cache.read(code)

      if false
        # エラーだったら同じとこにリダイレクトする
        if _ret[:alert_message]
          c.redirect_to [*url_prefix, redirect_params]
          return
        end
      end

      c.redirect_to post_redirect_path(redirect_params)
    end

    def render_in_view
      response_render(to_body_html)
    end

    def response_render(resp)
      # リダイレクトできた場合POSTの場合(_cache_ident付きで飛んでくる)は前回の実行結果を読み出している
      # as_rails_cache_store_key なしで来たときは実行している
      if resp
        if v = resp[:alert_message]
          h.flash.now[:alert] = v
        end
      end

      out = "".html_safe
      out << to_title_html
      out << to_form_html

      if resp
        if s = resp[:error_backtrace].presence
          out << h.bootstrap_label_p_tag("バックトレース", :type => "danger")
          out << h.bootstrap_alert(s, :type => :danger)
        end

        if resp[:result_rows].present?
          # グラフ用のフォーマットでないなら普通に表示
          if resp[:result_rows].kind_of?(String)
            out << resp[:result_rows].html_safe
          else
            # 得体の知れないオブジェクトは to_html が無い場合がある。たとえば true では to_html が使えない。
            out << html_format(resp[:result_rows]) # , :table_class => resp[:table_class])
            out << basic_paginate(resp[:result_object])
          end
          # end

          # if resp[:run_log].present?
          #   if admin_user.perm_or?(:script_sql)
          #     out << h.bootstrap_label_p_tag("SQL ログ")
          #     out << html_format(resp[:run_log].lines.collect{|e|[e]}) # , :table_class => "search_table")
          #   end
          # end
        end
      end

      # if Rails.env.development? || Rails.env.test?
      #   out << h.tag(:hr)
      #   out << resp.to_html(:title => "resp") if resp
      #   out << params.to_unsafe_h.to_html(:title => "params")
      #
      #   out << h.tag(:hr)
      #   out << h.content_tag(:div, :class => "well") do
      #     FrontScript.cloud_links(h)
      #   end
      # end

      out
    end

    def basic_paginate(s, **options)
      out = "".html_safe
      if s.respond_to?(:total_pages)
        out << h.content_tag(:div, h.page_entries_info(s))
        out << h.paginate(s, options)
      end
      out
    end

    def to_body_html
      if get? # このクラス固定のタイプであって controller.request.get? ではない
        v = script_body_run
      else
        # POSTのタイプのはリダイレクトしてキャッシュした内容を表示する
        v = cached_result
      end
      if v
        Response[v]
      end
    end

    private

    # オーバーライド微推奨
    # これをオーバーライドすれば run_log や alert_message などをも書き換えられる
    def script_body_run
      resp = {}
      resp[:result_rows] = any_object_to_result_rows(script_body)
      resp
    end

    def alert_log_subject
      "[#{label_name}][#{key}][#{form_action_method.upcase}]"
    end

    def alert_log_track(error)
      AlertLog.track("#{alert_log_subject}[#{error.class.name}][#{error.message}]", :body => {:error => error.message, :params => params, :class => error.class.name, :backtrace => error.backtrace}.pretty_inspect, :mail_notify => Rails.env.in?(["production", "staging", "development"]))
    end

    def alert_message_build(error)
      message = error.message.to_s.dup.force_encoding("UTF-8") # Faraday のエラーメッセージが ASCII-8BIT のため
      ERB::Util.html_escape("#{error.class.name}: #{message}")
    end

    def log_capture?
      request.format.html? && sql_log_display # && admin_user.perm_or?(:script_sql)
    end

    # script_body の中で使うために用意したメソッド
    concerning :Helper do
      def admin_user
        h.admin_user
      end

      def bold(str)
        h.tag.b(str)
      end

      def invisible(key)
        h.tag.span(key, :style => "display:none")
      end

      # タグを取ったとき他の数値と混ざらないように [] で囲む
      def sort_value(value)
        h.content_tag(:span, "[#{key}]", :style => "display:none")
      end

      def current_page
        params[:page].presence.to_i
      end

      def page_per(s)
        if v = current_per.presence
          s = s.page(current_page).per(v)
        end
        s
      end

      def current_per
        v = (params[:per].presence || 25).to_i
        if v.positive?
          v
        end
      end

      def form_part_per
        [
          {
            :label        => "1ページあたりの行数",
            :key          => :per,
            :type         => :integer,
            :default      => params[:per],
            :collapse     => params[:per].blank?,
            :placeholder  => current_per,
            :help_message => "0以下を指定するとページングしなくなるので件数が多いモデルの場合は気をつけてください",
          },
        ]
      end

      # def span_nowrap(value)
      #   if value.present?
      #     h.content_tag(:span, value, :class => "text-nowrap")
      #   end
      # end
      #
      # def div_nowrap(value)
      #   if value.present?
      #     h.content_tag(:div, value, :class => "text-nowrap")
      #   end
      # end

      # def help_message_tag_links(klass, tags_key = :tags)
      #   tags = klass.tag_counts_on(tags_key, :at_least => 1, :limit => 256)
      #   names = tags.collect(&:name)
      #   names.collect { |e| h.link_to(e, "#", :class => "tag_link button button-link") }.join(" ").html_safe
      # end

      # def __tooltip(name, tooltip = nil)
      #   if v = tooltip.presence
      #     name = h.content_tag(:span, name, h.bootstrap_tooltip_options(:tooltip => v))
      #   end
      #   name
      # end
    end

    concern :FormPartPerAppend do
      def form_parts
        super + form_part_per
      end
    end

    concerning :Parent do
      def other_response_params
        {}
      end
    end

    concerning :MenuHelper do
      class_methods do
        def to_menu_element(h, params = {}, **options)
          {
            :name     => h.bootstrap_icon(icon_key) + (options[:name] || label_name),
            :url      => script_link_path(params),
            # :if_match => {:controller => Admin::FrontScriptsController, :id => key},
          }
        end
      end
    end
  end

  class Response < Hash
    def to_result_label
      if time_label && bm_ms_str
        "#{time_label}の実行結果(#{bm_ms_str})"
      else
        "実行結果"
      end
    end

    private

    def time_label
      if self[:time]
        self[:time].to_time.to_s(:exec_distance)
      end
    end

    def bm_ms_str
      if self[:bm_ms]
        "%.1f ms" % self[:bm_ms]
      end
    end
  end
end
