module QuickScript
  concern :ControllerMod do
    def controller
      @options[:controller]
    end

    def session
      @session ||= controller.respond_to?(:session) ? controller.session : {}
    end

    ################################################################################

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

    ################################################################################

    def render_all
      if params[:__FOR_ASYNC_DATA__]
        render_for_ogp
      else
        AppLog.info(subject: "[#{self.class.name}]", body: params.to_t)
        render_for_content
      end
    end

    ################################################################################

    def render_for_content
      if controller
        controller.respond_to do |format|
          render_format(format)
        end
      end
    end

    def render_format(format)
      format.json { controller.render json: self, status: status_code }
    end

    def status_code
      params[:status_code].try { to_i }
    end

    ################################################################################

    def render_for_ogp
      if controller
        controller.respond_to do |format|
          format.json { controller.render json: meta_for_async_data, status: status_code }
        end
      end
    end
  end
end
