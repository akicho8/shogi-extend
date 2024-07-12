module QuickScript
  concern :ControllerMod do
    def controller
      @options[:controller]
    end

    def session
      @session ||= controller ? controller.session : {}
    end

    def request_format
      if Rails.env.local?
        if params[:_format]
          return params[:_format].to_sym
        end
      end

      if controller
        controller.request.format.to_sym
      end
    end

    def request_post?
      if Rails.env.local?
        if params[:_method].to_s == "post"
          return true
        end
      end

      if controller
        controller.request.post?
      end
    end

    def request_get?
      !request_post?
    end

    def all_content_render
      controller.respond_to do |format|
        render_format(format)
      end
    end

    def render_format(format)
      format.json { controller.render json: self }
    end
  end
end
