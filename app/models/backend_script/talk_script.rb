module BackendScript
  class TalkScript < ::BackendScript::Base
    self.category = "ツール"
    self.script_name = "読み上げテスト"

    def form_parts
      [
        {
          :label   => "文言",
          :key     => :message,
          :type    => :string,
          :default => current_message,
        },
      ]
    end

    def script_body
      if submitted?
        c.redirect_to talk_object.to_browser_path
      end
    end

    def current_message
      params[:message].presence
    end

    def talk_object
      Talk.new(source_text: current_message, disk_cache_enable: false)
    end
  end
end
