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
#   FooScript.new(@params).script_body
#
# ▼post後に別のところにリダイレクトするには？
#
#   def post_redirect_path(redirect_params)
#     script_link_path(:id => :foo)
#   end
#
module AtomicScript
  concern :Core do
    included do
      # 人間向けスクリプト名
      class_attribute :script_name
      self.script_name = nil

      delegate :key, :to => "self.class"
    end

    class_methods do
      def key
        @key ||= name.demodulize.underscore.remove(/_script\z/).dasherize
      end
    end

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

      @params = params
      @view_context = @params.delete(:view_context)
      @controller = @params.delete(:controller)
      if @controller
        @request = @controller.request
      end
    end

    def render_in_view
      response_render(to_body_html)
    end

    def response_render(resp)
      if resp
        if v = resp[:error_message]
          h.flash.now[:alert] = v
        end
      end

      out = "".html_safe
      out << to_title_html || ""
      out << to_form_html

      if resp
        if resp[:rows].present?
          out << h.tag.div(:class => "columns") do
            h.tag.div(:class => "column") do
              o = "".html_safe
              if resp[:rows].kind_of?(String)
                o << resp[:rows].html_safe
              else
                o << html_format(resp[:rows])
                o << basic_paginate(resp[:object])
              end
              o
            end
          end
        end
      end

      if Rails.env.development? || Rails.env.test?
        out << h.tag.div(:class => "box") { params.to_html(:title => "params") }
      end

      out
    end

    private

    def basic_paginate(s, **options)
      out = "".html_safe
      if s.respond_to?(:total_pages)
        out << h.content_tag(:div, h.page_entries_info(s))
        out << h.paginate(s, options)
      end
      out
    end

    def to_body_html
      v = script_body_run
      if v
        v = Response[v]
      end
      v
    end

    def to_form_html
      out = []
      if form_render?
        out << h.tag.div(:class => "columns") do
          h.tag.div(:class => "column") do
            out << h.form_with(url: submit_path, method: form_action_method, multipart: multipart?, skip_enforcing_utf8: true) do |;out|
              out = []
              out << FormBox::InputsBuilder::Default.inputs_render(form_parts)
              out << h.tag.div(:class => "field is-grouped") do
                h.tag.div(:class => "control") do
                  h.submit_tag(buttun_name, :class => form_submit_button_class, :name => "_submit")
                end
              end
              out.join.html_safe
            end
          end
        end
      end
      out.join.html_safe
    end

    def form_render?
      form_parts.present?
    end

    # オーバーライド
    def form_parts
      []
    end

    # オーバーライド
    def script_body
    end

    def script_body_run
      if false
        resp = {}
        begin
          object = script_body
          resp[:object] = object
          resp[:rows] = any_value_as_rows(object)
        rescue Exception => error
          resp[:error_message] = "#{error.class.name}: #{error.message}"
          resp[:error_backtrace] = error.backtrace.join("<br/>").html_safe
        end
        resp
      else
        resp = {}
        object = script_body
        resp[:object] = object
        resp[:rows] = any_value_as_rows(object)
        resp
      end

    end

    # 実行結果を可能な限り配列の配列に変換する
    #
    #   any_value_as_rows(1)           #=> 1
    #   any_value_as_rows([{:a => 1]}) #=> [[:a],[1]]
    #
    def any_value_as_rows(value)
      value ||= []
      case
      when value.kind_of?(ApplicationRecord) # Article.first
        value.attributes
      when value.kind_of?(ActiveRecord::Relation) # Article.all
        value.to_a.collect(&:attributes)
      when value.kind_of?(Array) && value.all? { |e| e.kind_of?(ApplicationRecord) } # Article.all.to_a
        value.collect(&:attributes)
      else
        value
      end
    end

    def to_title_html
    end

    def multipart?
      Array.wrap(form_parts).any? { |e| e[:type] == :file }
    end

    def form_action_method
      :get
    end

    def submit_path
      [*url_prefix, id: key]
    end

    def buttun_name
      "実行"
    end

    def form_submit_button_class
      ["button", "is-small", "is-link", *form_submit_button_color]
    end

    def form_submit_button_color
      "is-primary"
    end

    def submitted?
      @params[:_submit].present?
    end
  end
end
