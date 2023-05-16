# 空き容量の取得
#
#  FreeSpace.new.call {} # => ["80%", "70%"]
#  FreeSpace.new.call    # => "80%"
#
class FreeSpace
  def initialize(options = {})
    @options = {
      :command => "df --o=pcent / | tail -1",
    }.merge(options)
  end

  def call(&block)
    AppLog.trace(["#{__FILE__}:#{__LINE__}", __method__, ])
    if block
      av = []
      begin
        av << percentage
        yield
      ensure
        av << percentage
      end
      av
    else
      percentage
    end
  end

  private

  def percentage
    %x(#{@options[:command]}).strip
  end
end
