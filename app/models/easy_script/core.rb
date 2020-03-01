# 組み込みスクリプトの本体
#
# ▼POSTタイプのときにsubmitする前の段階で何か実行させるには？
#
#   def show_action
#     unless target_record.group_info
#       c.redirect_to(script_link_path(:id => :foo))
#     end
#     super
#   end
#
# ▼script_bodyの中から他のクラスに委譲するには？
#
#   FooScript.new(:current_user => current_user, :view_context => view_context, :controller => controller).script_body
#   または
#   FooScript.new(@org_params).script_body
#
# ▼post後に別のところにリダイレクトするには？
#
#   def post_redirect_path(redirect_params)
#     script_link_path(:id => :foo)
#   end
#
module EasyScript
  concern :Core do
    included do
      # 人間向けスクリプト名
      class_attribute :script_name
      self.script_name = nil

      # POSTでフォームを送信するか？
      class_attribute :post_method_use_p
      self.post_method_use_p = false

      # URLを生成するときのプレフィクス
      class_attribute :url_prefix
      self.url_prefix = []

      delegate :key, :to => "self.class"
    end

    class_methods do
      def key
        name.demodulize.underscore.remove(/_script\z/).dasherize
      end
    end

    extend ActiveModel::Translation

    attr_accessor :params
    attr_accessor :view_context
    attr_accessor :request
    attr_accessor :controller

    alias :h :view_context
    alias :c :controller

    def initialize(params)
      if params.respond_to?(:to_unsafe_h)
        params = params.to_unsafe_h
      end

      @org_params = params
      @params = params
      @view_context = @params.delete(:view_context)
      @controller = @params.delete(:controller)
      if @controller
        @request = @controller.request
      end
    end

    # オーバーライドして PNG に対応する例
    #
    #   def show_action
    #     if request.format.png?
    #       xfile = Xfile.find(params[:xfile_id])
    #       if Pathname(xfile.attachment.path).exist?
    #         path = xfile.attachment.path
    #       else
    #         path = xfile.attachment.url
    #       end
    #       bin = open(path).read
    #       image = Magick::Image.from_blob(bin).first
    #       image.format = "PNG"
    #       c.send_data(image.to_blob, :type => Mime[:png], :filename => "#{xfile.key}.png")
    #     end
    #
    #     super
    #   end
    #
    def show_action
      if c.performed?
        return
      end

      # unless c.performed?
      #   controller.respond_to do |format|
      #     # format.csv { controller.send_data(to_body_html.to_ucsv, :type => Mime[:csv], :disposition => "attachment; filename=#{script_name}.csv") }
      #     format.all
      #   end
      # end
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

    def create_or_update_action
      _ret = script_body_run

      # script_body の中ですでにリダイレクトしていればそれを優先してこちらでは何もしない
      if c.performed?
        return
      end

      # POST で User.all.to_a などを返すと AR の配列が Marshal.dump されて undefined class/module な現象が起きる。
      # これはmemcachedへのMarshalの不具合。
      #
      # undefined class/module とか言われてアプリの起動ができなくなってしまう
      # http://xibbar.hatenablog.com/entry/20130221/1361556846
      #
      as_rails_cache_store_key = SecureRandom.hex
      Rails.cache.write(as_rails_cache_store_key, _ret, :expires_in => 3.minutes)

      c.redirect_to post_redirect_path(clean_params.merge(:as_rails_cache_store_key => as_rails_cache_store_key))
    end

    # def url_prefix
    #   self.class.url_prefix
    # end

    def post_redirect_path(redirect_params)
      [*url_prefix, redirect_params]
    end

    def render_in_view
      response_render(to_body_html)
    end

    def response_render(resp)
      # リダイレクトできた場合POSTの場合( as_rails_cache_store_key t付きで飛んでくる)は前回の実行結果を読み出している
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
        end
      end

      # if Rails.env.development? || Rails.env.test?
      #   out << h.tag(:hr)
      #   out << resp.to_html(:title => "resp") if resp
      #   out << params.to_unsafe_h.to_html(:title => "params")
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

    def to_form_html
      out = []
      if form_parts.present? || post_method_use_p
        out << h.form_with(url: submit_path, method: form_action_method, multipart: multipart?, skip_enforcing_utf8: true) do |;out|
          out = []
          out << FormBox::InputsBuilder::Default.inputs_render(form_parts)
          out << h.tag.div(:class => "field is-grouped") do
            h.tag.div(:class => "control") do
              h.submit_tag(buttun_label, :class => form_submit_button_class, :name => "_submit")
            end
          end
          out.join.html_safe
        end
      end
      out.join.html_safe
    end

    def clean_params
      params.except(:controller, :action, :_method, :authenticity_token, :id, :utf8, :_submit)
    end

    private

    #
    # 実行結果を可能な限り配列の配列に変換する
    #
    #   any_object_to_result_rows(1)           #=> 1
    #   any_object_to_result_rows([{:a => 1]}) #=> [[:a],[1]]
    #
    def any_object_to_result_rows(object)
      object ||= []
      case
      when object.kind_of?(ApplicationRecord) # AR.find(1)
        # Article.first などの結果
        object.attributes
      when object.kind_of?(ActiveRecord::Relation) # && object.first.kind_of?(ApplicationRecord)
        # Article.page(params[:page]).per(params[:per_page]) で取得した結果
        object.to_a.collect(&:attributes) # ここで SQL を生成するので db_anchor の外になってしまう場合がある
      when object.kind_of?(Array) && object.all?{|e|e.kind_of?(ApplicationRecord)}
        # db_anchor のなかで仕方なく to_a したときの戻り値を拾う
        object.collect(&:attributes)
      when object.kind_of?(Proc) # AR.find(1)
        # 大事なコードをバックグラウンドで実行して最後にエラーになるのは厭なので例外にはしない
        object.inspect
      else
        # そのまま
        object
      end
    end

    def to_title_html
      h.instance_variable_set(:@page_title, script_name)
      h.tag.div(h.instance_variable_get(:@page_title), :class => "title is-4 yumincho")
    end

    # オーバーライド微推奨
    # これをオーバーライドすれば run_log や alert_message などをも書き換えられる

    # resp = {}
    # begin
    #   result_object = nil
    #   run_log     = nil
    #   bm_ms = Benchmark.ms do
    #     run_log = LogCapture.log_capture_sw(log_capture?) do
    #       result_object = script_body || ""  # ここで実行している
    #     end
    #   end
    #   resp[:result_object] = result_object
    #   resp[:result_rows] = any_object_to_result_rows(result_object)
    #   resp[:run_log] = run_log
    #   resp[:time] = Time.current
    #   resp[:bm_ms] = bm_ms
    # rescue Exception => error
    #   resp[:alert_message] = alert_message_build(error)
    #   resp[:error_backtrace] = error.backtrace.join("<br/>").html_safe
    #   alert_log_track(error)
    #   if Rails.env.test?
    #     pp error
    #     pp error.backtrace
    #   end
    # ensure
    #   unless Rails.env.test?
    #     unless error
    #       AlertLog.track("#{alert_log_subject}[終了] #{'%.2f' % (resp[:bm_ms].to_f / 1000)} s", :body => params.pretty_inspect)
    #     end
    #   end
    # end
    # resp.merge(other_response_params)

    # オーバーライド微推奨
    # これをオーバーライドすれば run_log や alert_message などをも書き換えられる
    def script_body_run
      result_object = script_body || ""  # ここで実行している
      resp = {}
      resp[:result_rows] = any_object_to_result_rows(result_object)
      resp
    end
    # def script_body_run
    #   {:script_retval => script_body}
    # end

    # オーバーライド
    def form_parts
      []
    end

    # オーバーライド
    def script_body
    end

    def multipart?
      Array.wrap(form_parts).any? { |e| e[:type] == :file }
    end

    def get?
      !post_method_use_p
    end

    def form_action_method
      post_method_use_p ? :put : :get
    end

    def cached_result
      if redirected?
        Rails.cache.read(as_rails_cache_store_key)
      end
    end

    def redirected?
      as_rails_cache_store_key
    end

    def as_rails_cache_store_key
      @params[:as_rails_cache_store_key]
    end

    def submit_path
      @params[:_submit_path] || [*url_prefix, :id => key]
    end

    def buttun_label
      if get?
        get_buttun_label
      else
        post_buttun_label
      end
    end

    def get_buttun_label
      "実行"
    end

    def post_buttun_label
      "本当に実行する"
    end

    def form_submit_button_class
      "button is-small is-link #{form_submit_button_color}"
    end

    def form_submit_button_color
      if get?
        'is-primary'
      else
        'is-danger'
      end
    end

    # script_body の中で使うために用意したメソッド
    concerning :Helper do
      def submitted?
        @params[:_submit].present?
      end
    end
  end
end
