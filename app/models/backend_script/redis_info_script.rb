module BackendScript
  class RedisInfoScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "Redis Info"

    def script_body
      Redis.new.info
    end
  end
end
