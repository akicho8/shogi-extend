# 空き容量の取得
#
#  FreeSpace.new.call {} # => ["80%", "70%"]
#  FreeSpace.new.call    # => "80%"
#
class FreeSpace
  cattr_accessor(:base_command) {
    if RUBY_PLATFORM.include?("darwin")
      "gdf"
    else
      "df"
    end
  }

  def initialize(options = {})
    @options = {
      :command => "#{base_command} --o=pcent / | tail -1",
    }.merge(options)
  end

  def call(&block)
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
