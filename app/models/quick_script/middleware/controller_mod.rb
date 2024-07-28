module QuickScript
  module Middleware
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
          if params[:_method].to_s == "post" || @options[:_method].to_s == "post"
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

      def render_anything
        if params[:__FOR_ASYNC_DATA__]
          render_for_ogp_crawler
        else
          render_for_basic_content
        end
      end

      ################################################################################

      def render_for_basic_content
        if controller
          controller.respond_to do |format|
            render_format(format)
          end
        end
      end

      def render_format(format)
        format.json { controller.render json: self, status: status_code }
      end

      ################################################################################

      def render_for_ogp_crawler
        if controller
          controller.respond_to do |format|
            format.json { controller.render json: meta_for_async_data, status: status_code }
          end
        end
      end
    end
  end
end
