class ErrorTextBuilder
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
      av += @exception.backtrace.take(@options[:backtrace_lines_max])
    end
    if v = @options[:data]
      av << v.pretty_inspect
    end
    av.compact.join("\n")
  end
end
