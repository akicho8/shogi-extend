
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
      out = "".html_safe
      if resp
        resp = ResponseDecorator[resp]
        out << response_render_body(resp)
      end
      out
    end

    private

    def response_render_body(resp)
      if resp[:rows].present?
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

    def basic_paginate(s, options = {})
      out = "".html_safe
      if s.respond_to?(:total_pages)
        out << h.content_tag(:div, h.page_entries_info(s))
        out << h.paginate(s, options)
      end
      out
    end

    def to_body_html
      script_body_run
    end

    # オーバーライド
    def script_body
    end

    def script_body_run
      object = script_body

      resp = {}
      resp[:object] = object
      resp[:rows] = any_value_as_rows(object)
      resp
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
  end
end
