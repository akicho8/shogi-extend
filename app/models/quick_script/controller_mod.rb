module QuickScript
  concern :ControllerMod do
    prepended do
      class_attribute :form_method, default: nil
    end

    def as_json(*)
      super.merge(form_method: form_method)
    end

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

    def render_all
      controller.respond_to do |format|
        render_format(format)
      end
    end

    def render_format(format)
      format.json { controller.render json: self }
    end
  end
end
