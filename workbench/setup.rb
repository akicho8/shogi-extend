require File.expand_path('../../config/environment', __FILE__)
ActiveRecord::Base.connection.disable_query_cache!

module WorkbenchExtension
  def _(n = 1)
    "%.2f ms" % Benchmark.ms { n.times { yield } }
  end

  def sql(&block)
    if block
      begin
        logger = ActiveRecord::Base.logger
        ActiveRecord::Base.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
        yield
      ensure
        ActiveRecord::Base.logger = logger
      end
    else
      ActiveRecord::Base.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    end
  end

  def log(&block)
    if block
      begin
        logger = Rails.logger
        Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
        yield
      ensure
        Rails.logger = logger
      end
    else
      Rails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    end
  end

  def s(...)
    sql(...)
  end

  def l(...)
    log(...)
  end
end

include WorkbenchExtension
