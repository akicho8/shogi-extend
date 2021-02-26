module AtomicScript
  concern :ErrorShowMethods do
    def script_body_run
      begin
        super
      rescue StandardError, SyntaxError => error
        {
          error: {
            message: "#{error.class.name}: #{error.message}",
            backtrace: error.backtrace.take(2).join("<br/>").html_safe,
          },
        }
      end
    end

    def response_render_body(resp)
      out = super || "".html_safe

      if error = resp[:error]
        if v = error[:message]
          h.flash.now[:alert] = v
        end

        if v = error[:backtrace]
          out << h.tag.div(:class => "columns") do
            h.tag.div(:class => "column") do
              h.tag.pre(v)
            end
          end
        end
      end

      out
    end
  end
end
