module BackendScript
  class ExampleArPaggingScript < ::BackendScript::Base
    self.category = "スクリプト例"
    self.script_name = "ARページングのテスト"

    def form_parts
      [
        {
          :label   => "per",
          :key     => :per,
          :type    => :integer,
          :default => params[:per],
        },
      ]
    end

    def script_body
      page_per(AlertLog)
    end
  end
end
