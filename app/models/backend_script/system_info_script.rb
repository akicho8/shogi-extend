module BackendScript
  class SystemInfoScript < ::BackendScript::Base
    self.script_name = "システム情報"

    TIME_THAT_THIS_PROCESS_HAS_STARTED = Time.current

    def script_body
      [

        { name: "ブート",          func: proc { boot_time }},
        { name: "sidekiq",         func: proc { active_check("sidekiq") }},
        { name: "puma",            func: proc { active_check("puma")    }},
        { name: "nginx",           func: proc { active_check("nginx")   }},
        { name: "sidekiq (ps)",    func: proc { ps_aux("sidekiq")       }},
        { name: "puma (ps)",       func: proc { ps_aux("puma")          }},
        { name: "nginx (ps)",      func: proc { ps_aux("nginx")         }},
        { name: "Rails Cache",     func: proc { rails_cache                               }},
        { name: "ARテーブル数",    func: proc { ApplicationRecord.connection.tables.size }},
        { name: "SMTP設定",        func: proc { ActionMailer::Base.smtp_settings          }},
        { name: "df",              func: proc { %x{df -H / | tail -1}                     }},
        { name: "uname",           func: proc { %x{uname -a}                              }},
        { name: "uptime",          func: proc { %x{uptime}                                }},
        { name: "hostname",        func: proc { %x{hostname}                              }},
        { name: "whoami",          func: proc { %x{whoami}                                }},
        { name: "Rails.env",       func: proc { Rails.env                                 }},
        { name: "migrate version", func: proc { ActiveRecord::Migrator.current_version    }},
        # {category: "App", name: "Sidekiq",         func: proc { sidekiq_stats                             }},
      ].inject({}) do |a, e|
        a.merge(e[:name] => func_run(e[:func]))
      end
    end

    def func_run(func)
      begin
        instance_eval(&func)
      rescue Exception => error
        h.content_tag(:span, error.inspect, :class => "has-text-danger")
      end
    end

    def ok_or_ng(value)
      if value
        h.content_tag(:span, "OK", :class => "has-text-success")
      else
        h.content_tag(:span, "NG", :class => "has-text-danger")
      end
    end

    def rails_cache
      key, value = SecureRandom.hex, SecureRandom.hex
      Rails.cache.write(key, value, expires_in: 1)
      ok_or_ng Rails.cache.read(key) == value
    end

    def active_check(command)
      if Rails.env.test?
        return
      end
      `sudo systemctl status #{command} | grep Active | head -1`.strip
    end

    def ps_aux(command)
      `ps auxwww | grep #{command} | head -1`.strip
    end

    def boot_time
      a = TIME_THAT_THIS_PROCESS_HAS_STARTED
      b = Time.current

      out = []
      out << a.strftime("%F %T")
      s = ApplicationController.helpers.distance_of_time_in_words(a, b, include_seconds: true)
      out << "(#{s})"
      out.join(" ")
    end

    # def sidekiq_stats
    #   s = Sidekiq::Stats.new
    #   {
    #     processed:       s.processed,
    #     failed:          s.failed,
    #     busy:            s.workers_size,
    #     processes:       s.processes_size,
    #     enqueued:        s.enqueued,
    #     scheduled:       s.scheduled_size,
    #     retries:         s.retry_size,
    #     dead:            s.dead_size,
    #     default_latency: s.default_queue_latency
    #   }
    # end
  end
end
