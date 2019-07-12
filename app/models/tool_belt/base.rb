module ToolBelt
  class Base
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def to_html
      return unless Rails.env.development?

      h.tag.div(builder.join.html_safe, :class => "box tool_belt is_screen_only")
    end

    private

    def builder
      []
    end

    def link_to_eval(name, **options, &block)
      if code = block.call
        h.link_to(name, h.eval_path(options.merge(code: code)), method: :put, :class => "button is-small")
      end
    end

    def h
      params[:view_context]
    end
  end
end
