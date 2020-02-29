# 一時的にログを文字列として取得する
module LogCapture
  extend self

  def log_capture_sw(enable = true, &block)
    if enable
      log_capture(&block)
    else
      block.call
      ""
    end
  end

  def log_capture(&block)
    io = StringIO.new
    save_colorize_logging = ActiveSupport::LogSubscriber.colorize_logging
    save_logger = ApplicationRecord.logger
    ActiveSupport::LogSubscriber.colorize_logging = false
    ApplicationRecord.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(io))
    begin
      yield
    ensure
      ApplicationRecord.logger = save_logger
      ActiveSupport::LogSubscriber.colorize_logging = save_colorize_logging
    end
    io.string
  end

  def log_capture_lines(line, &block)
    if line.present? && line >= 1
      log_capture(&block).lines.take(line).join
    else
      yield
      nil
    end
  end
end
