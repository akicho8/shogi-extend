module BackendScript
  class SidekiqConpaneScript < ::BackendScript::Base
    self.category = "sidekiq"
    self.script_name = "Sidekiq コンパネ"

    def script_body
      c.redirect_to "/admin/sidekiq"
    end
  end
end
