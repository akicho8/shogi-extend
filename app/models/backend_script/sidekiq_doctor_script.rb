require "etc"

module BackendScript
  class SidekiqDoctorScript < ::BackendScript::Base
    # include AtomicScript::PostRedirectMod
    self.script_name = "Sidekiq 動作検証"

    def form_parts
      [
        {
          :label   => "コード",
          :key     => :code,
          :type    => :string,
          :default => default_code,
        },
      ]
    end

    def script_body
      SidekiqDoctorJob.perform_later(code: params[:code])
      AlertLog.order(created_at: :desc).take(10)
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
