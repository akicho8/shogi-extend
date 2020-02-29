module AdminScript
  class EnvScript < Base
    self.category = "その他"
    self.label_name = "ENV"
    self.icon_key = :info

    def script_body
      ENV.sort_by { |key, val| key }.to_h
    end
  end
end
