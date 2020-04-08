module BackendScript
  class RemoteIpScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "リモートIP"

    def script_body
      [
        %(request.ip),
        %(request.remote_ip),
        %(request.env["HTTP_CLIENT_IP"]),
        %(request.env["HTTP_X_FORWARDED_FOR"]),
        %(request.env["REMOTE_ADDR"]),
        %(request.env["REMOTE_HOST"]),
      ].inject({}) do |a, e|
        a.merge(e => eval(e))
      end
    end
  end
end
