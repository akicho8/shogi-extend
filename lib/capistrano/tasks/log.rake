set_if_empty :log_tail_limit, 500

[
  { task: :access_log, default: -> { "/var/log/httpd/access_log" },                    },
  { task: :error_log,  default: -> { "/var/log/httpd/error_log" },                     },
  { task: :cron_log,   default: -> { "/var/log/cron" },                                },
  { task: :mail_log,   default: -> { "/var/log/mail_log" },                            },
  { task: :log,        default: -> { "#{shared_path}/log/#{fetch(:rails_env)}.log" },  },
].each do |e|
  desc "tail #{e[:task]}}"
  task "#{e[:task]}" do
    on roles(:all) do
      file = fetch("#{e[:task]}_path", e[:default].call)
      execute :sudo, :tail, "-#{fetch(:log_tail_limit)}", file
    end
  end

  desc "tailf #{e[:task]}"
  task "#{e[:task]}:tailf" do
    on roles(:all) do
      file = fetch("#{e[:task]}_path", e[:default].call)
      execute :sudo, :tailf, file
    end
  end

  desc "download #{e[:task]}"
  task "#{e[:task]}:download" do
    on roles(:all) do
      file = fetch("#{e[:task]}_path", e[:default].call)
      download! file, "log"
    end
  end
end
