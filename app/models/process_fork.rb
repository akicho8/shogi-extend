# ▼Sidekiqのメモリが増え続ける問題対処 - Qiita
# https://qiita.com/ktanoooo/items/55228112d7f2e8000b1c
#
# rails r 'ProcessFork.call{}'
#
module ProcessFork
  extend self

  def call
    # tracking if the op failed for the Process exit
    logging("remove_connection")
    config = ActiveRecord::Base.remove_connection
    logging(config)
    pid = Process.fork do
      logging("fork in")
      begin
        ActiveRecord::Base.establish_connection(config)

        # This is needed to re-initialize the random number generator after forking (if you want diff random numbers generated in the forks)
        srand

        # Run the closure passed to the fork_with_new_connection method
        logging("fork in call before")
        yield
        logging("fork in call after")

      rescue Exception => exception
        logging(exception)
        puts "Forked operation failed with exception: " + exception
      ensure
        logging("ActiveRecord::Base.remove_connection")
        ActiveRecord::Base.remove_connection
        logging("Process.exit!")
        Process.exit!
      end
      logging("fork out")
    end
    logging("fork pid: #{pid}")

    ActiveRecord::Base.establish_connection(config)

    # return the process id
    logging("Process.waitpid(#{pid})")
    Process.waitpid(pid)
  end

  def logging(str)
    time = Time.current.strftime("%F %T")
    Rails.logger.info("[#{time}][ProcessFork][PID:#{Process.pid}] #{str}")
  end
end
