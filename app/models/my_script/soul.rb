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
module MyScript
  class Soul
    extend ActiveModel::Translation

    attr_accessor :params, :view_context, :request, :controller

    alias :h :view_context
    alias :c :controller

    class_attribute :label_name
    self.label_name = nil

    class_attribute :post_submit
    self.post_submit = false

    def self.key
      name.demodulize.underscore.remove(/_script\z/)
    end

    def self.url_prefix
      [:my_script]
    end

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
      #     # format.csv { controller.send_data(to_body_html.to_ucsv, :type => Mime[:csv], :disposition => "attachment; filename=#{label_name}.csv") }
      #     format.all
      #   end
      # end
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

    def url_prefix
      self.class.url_prefix
    end

    def post_redirect_path(redirect_params)
      [*url_prefix, redirect_params]
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
        if resp[:script_retval].present?
          out << resp[:script_retval]
        end
      end

      out
    end

    def to_body_html
      if get? # このクラス固定のタイプであって controller.request.get? ではない
        script_body_run
      else
        # POSTのタイプのはリダイレクトしてキャッシュした内容を表示する
        cached_result
      end
    end

    def to_form_html
      out = []
      if form_parts.present? || post_submit
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
      h.instance_variable_set(:@page_title, label_name)
      h.tag.div(h.instance_variable_get(:@page_title), :class => "title is-4 yumincho")
    end

    # オーバーライド微推奨
    # これをオーバーライドすれば run_log や alert_message などをも書き換えられる
    def script_body_run
      {:script_retval => script_body}
    end

    # オーバーライド推奨
    def form_parts
      []
    end

    # オーバーライド推奨
    def script_body
    end

    def multipart?
      Array.wrap(form_parts).any? { |e| e[:type] == :file }
    end

    def get?
      !post_submit
    end

    def form_action_method
      post_submit ? :put : :get
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

    delegate :key, :to => :class

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
      included do
        delegate :script_link_path, :to => "self.class"
      end

      class_methods do
        def script_link_path(params = {})
          if params[:anchor]
            params = params.merge(:__anchor__ => params[:anchor]) # アンカーを使おうとしたことをわかるようにするため
          end
          [*url_prefix, {:id => key}.merge(params)]
        end
      end

      def submitted?
        @params[:_submit].present?
      end

      # 自分のページにリンクするには？
      #   self_link_to("確認", :foo => 1)
      # 別のスクリプトにリンクするには？
      #   self_link_to("確認", :id => "abc_script", :foo => 1)
      def script_link_to(name, params, **html_options)
        if request.format.html?
          h.link_to(name, script_link_path(params), html_options) # ← テストするとここで大量の警告がでる。action が文字列なのがまずい。そもそもどこからやってきている？
        else
          name
        end
      end
    end
  end
end
