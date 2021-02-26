module BackendScript
  class RailsConsoleScript < ::BackendScript::Base
    # include AtomicScript::PostRedirectMethods
    include AtomicScript::ErrorShowMethods

    self.category = "コンソール"
    self.script_name = "コード実行"

    def form_parts
      [
        {
          :label   => "コード",
          :key     => :eval_code,
          :type    => :text,
          :default => current_eval_code_str,
        },
      ] + super
    end

    def script_body
      eval(current_eval_code_str, binding, "")
    end

    def current_eval_code_str
      params[:eval_code].presence.to_s
    end
  end
end
