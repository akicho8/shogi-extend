module BackendScript
  class EnvScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "ENV"

    def script_body
      ENV.sort_by { |key, val| key }.to_h
    end
  end
end
