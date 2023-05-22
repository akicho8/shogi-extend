# エラーを通知しやすい形式に変換する
#
#  obj = ErrorInfo.new(((1 / 0) rescue $!), data: "(data)", backtrace_lines_max: 1)
#  hv = obj.to_h
#  hv[:emoji] # => ":SOS:"
#  hv[:subject] # => "divided by 0 (ZeroDivisionError)"
#
class ErrorInfo
  def initialize(exception, options = {})
    @exception = exception
    @options = {
      :backtrace_lines_max => 8,
    }.merge(options)
  end

  def to_h
    {
      :emoji   => ":SOS:",
      :subject => subject,
      :body    => body,
    }
  end

  private

  def subject
    [
      @exception.message.to_s.lines.first,
      "(#{@exception.class.name})"
    ].compact.join(" ")
  end

  def body
    av = []
    if @exception.message
      av << [
        "[MESSAGE]",
        @exception.message.rstrip,
      ].join("\n")
    end
    if @exception.backtrace
      av << [
        "[BACKTRACE]",
        *@exception.backtrace.take(@options[:backtrace_lines_max]),
      ].join("\n")
    end
    if v = @options[:data]
      av << [
        "[DATA]",
        v.pretty_inspect.rstrip,
      ].join("\n")
    end
    av.compact.join("\n\n")
  end
end
