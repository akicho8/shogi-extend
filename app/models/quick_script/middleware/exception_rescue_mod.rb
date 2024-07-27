module QuickScript
  module Middleware
    concern :ExceptionRescueMod do
      if Rails.env.local?
        def safe_call
          begin
            call
          rescue => error
            {
              _component: "QuickScriptViewValueAsPre",
              _v_bind: {
                value: error_to_text(error),
              },
            }
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
end
