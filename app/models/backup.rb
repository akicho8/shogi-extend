# -*- compile-command: "cap staging deploy:upload FILES=app/models/backup.rb" -*-

class Backup
  class << self
    def call(...)
      new(...).call
    end
  end

  def call
    begin
      p "バックアップ開始: #{Time.current}"
      system! "sudo mkdir -p #{output_dir}"
      system! "sudo chmod a+rw #{output_dir}"
      system! "mysqldump -u #{db_config[:username]} --password=#{db_config[:password]} --comments --add-drop-table --quick --single-transaction #{db_config[:database]} #{info[:tables].join(" ")} | gzip > #{output_file}"
      FileUtils.rm(target_delete_files, verbose: true)
      p "バックアップ完了: #{Time.current}"
    rescue => error
      ExceptionNotifier.notify_exception(error)
      raise error
    end
  end

  private

  def output_file
    output_dir.join("#{db_config[:database]}_#{timestamp}.sql.gz")
  end

  def target_delete_files
    backup_files - backup_files.last(info[:keep])
  end

  def backup_files
    output_dir.glob("*.sql.gz")
  end

  def output_dir
    Pathname("/var/backup")
  end

  def timestamp
    Time.current.strftime("%Y%m%d_%H%M%S")
  end

  def system!(command)
    puts command
    system(command, exception: true)
  end

  def db_config
    ActiveRecord::Base.connection_db_config.configuration_hash
  end

  def info
    settings_for_environments.fetch(Rails.env)
  end

  def settings_for_environments
    {
      "development" => { keep:  1, tables: ["users"], },
      "test"        => { keep:  1, tables: ["users"], },
      "staging"     => { keep:  1, tables: [],        },
      "production"  => { keep: 30, tables: [],        },
    }
  end
end
