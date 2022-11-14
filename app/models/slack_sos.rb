# ▼送信
# rails r "SlackSos.notify_exception(Exception.new)"
# rails r 'SlackSos.notify_exception((1/0 rescue $!))'
class SlackSos
  class << self
    def notify_exception(exception, options = {})
      new(exception, options).notify
    end
  end

  attr_reader :exception
  attr_reader :options

  def initialize(exception, options = {})
    @exception = exception
    @options = {
      backtrace_lines_max: 4,
    }.merge(options)
  end

  def notify
    SlackAgent.notify(emoji: ":SOS:", subject: exception.class.name, body: body)
  end

  private

  def body
    av = []
    if exception.message
      av << exception.message
    end
    if exception.backtrace
      av += exception.backtrace.take(options[:backtrace_lines_max])
    end
    if v = options[:data]
      av << v.pretty_inspect
    end
    av.compact.join("\n")
  end
end
