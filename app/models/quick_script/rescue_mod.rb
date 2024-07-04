module QuickScript
  concern :RescueMod do
    def safe_call
      begin
        call
      rescue => error
        {
          _component: "QuickScriptShowValueAsPre",
          body: error_to_text(error),
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
