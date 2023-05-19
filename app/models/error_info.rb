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
      :backtrace_lines_max => 4,
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
      av << @exception.message
    end
    if @exception.backtrace
      av << @exception.backtrace.take(@options[:backtrace_lines_max])
    end
    if v = @options[:data]
      av << v.pretty_inspect
    end
    av.compact.join("\n\n")
  end
end
