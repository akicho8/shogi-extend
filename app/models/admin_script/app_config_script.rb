module AdminScript
  class AppConfigScript < Base
    self.category = "その他"
    self.label_name = "AppConfig"
    self.icon_key = :info

    def script_body
      AppConfig
    end
  end
end
