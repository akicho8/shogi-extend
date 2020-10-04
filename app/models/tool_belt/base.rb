module ToolBelt
  class Base
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def to_html
      return unless Rails.env.development?

      h.tag.div(build.join.html_safe, :class => "box tool_belt")
    end

    private

    def build
      []
    end

    def link_to_eval(name, options = {}, &block)
      if code = block.call
        options = options.merge(code: code)
        if options[:redirect_to]
          options[:redirect_to] = h.url_for(options[:redirect_to])
        end
        h.link_to(name, h.eval_path(options), method: :put, :class => "button is-small")
      end
    end

    def h
      params[:view_context]
    end
  end
end
