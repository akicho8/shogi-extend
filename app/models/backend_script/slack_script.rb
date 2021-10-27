module BackendScript
  class SlackScript < ::BackendScript::Base
    self.category = "ツール"
    self.script_name = "Slack通知"

    def form_parts
      [
        {
          :label   => "発言",
          :key     => :message,
          :type    => :string,
          :default => current_message,
        },
      ]
    end

    def script_body
      if submitted?
        h.slack_notify(subject: "admin", body: current_message)
      end
    end

    def current_message
      params[:message].presence
    end
  end
end
