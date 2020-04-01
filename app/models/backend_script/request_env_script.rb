module BackendScript
  class RequestEnvScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "リクエスト時環境変数"

    def script_body
      request.env
    end
  end
end
