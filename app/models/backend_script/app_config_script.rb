module BackendScript
  class AppConfigScript < Base
    self.category = "その他"
    self.script_name = "AppConfig"

    def script_body
      AppConfig
    end
  end
end
