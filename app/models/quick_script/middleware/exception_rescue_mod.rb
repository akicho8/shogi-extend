module QuickScript
  module Middleware
    concern :ExceptionRescueMod do
      def safe_call
        if Rails.env.development? || params[:__EXCEPTION_RESCUE__]
          begin
            super
          rescue => error
            AppLog.error(error)
            {
              _component: "QuickScriptViewValueAsPre",
              _v_bind: {
                value: error_to_text(error),
              },
            }
          end
        else
          super
        end
      end

      private

      def error_to_text(error)
        text = []
        text << "#{error.message} (#{error.class.name})"
        text << ""
        text += error.backtrace
        text.join("\n")
      end
    end
  end
end
