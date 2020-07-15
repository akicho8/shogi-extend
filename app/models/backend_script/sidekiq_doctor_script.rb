require "etc"

module BackendScript
  class SidekiqDoctorScript < ::BackendScript::Base
    # include AtomicScript::PostRedirectMod
    self.category = "sidekiq"
    self.script_name = "Sidekiq 動作検証"

    def form_parts
      [
        {
          :label   => "コード",
          :key     => :code,
          :type    => :string,
          :default => current_code,
        },
      ]
    end

    def script_body
      if submitted?
        SidekiqDoctorJob.perform_later(code: current_code)
        AlertLog.order(created_at: :desc).take(10)
      end
    end

    def current_code
      params[:code].presence || default_code
    end

    def default_code
      %([Rails.env, Time.current.strftime("%F %T"), Dir.pwd, Etc.getlogin])
    end

    def redis_connection
      Sidekiq.redis do |conn|
        c = conn.connection
        "redis://#{c[:location]}/#{c[:db]}"
      end
    end

    def namespace
      @ns ||= Sidekiq.redis { |conn| conn.respond_to?(:namespace) ? conn.namespace : nil }
    end
  end
end
