# フロント側の Data URI Scheme 形式のバイナリ化
#
#  body = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABlBMVEUAAP////973JksAAAAAWJLR0QB/wIt3gAAAAd0SU1FB+YIHwktKVmKpzsAAAALSURBVAjXY2BABQAAEAABocUhwQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMi0wOC0zMVQwOTo0NTo0MSswMDowMCXHz4IAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjItMDgtMzFUMDk6NDU6NDErMDA6MDBUmnc+AAAAAElFTkSuQmCC"
#  object = DataUri.new(body)
#  object.to_blob       # => "..."
#  object.read         # => "..."
#  object.content_type # => "image/png"
#
require "base64"

class DataUri
  REGEXP_FORMAT = /\A(?:data):(?<content_type>.*?);base64,(?<base64_text>.*)/

  def initialize(body)
    @body = body
  end

  def to_blob
    # https://docs.ruby-lang.org/ja/latest/class/Base64.html
    @to_blob ||= Base64.decode64(parsed_attrs["base64_text"])
  end

  def to_data_uri
    "data:#{content_type};base64,#{Base64.strict_encode64(to_blob)}"
  end

  def read
    to_blob
  end

  def mime
    @mime ||= MiniMime.lookup_by_content_type(parsed_attrs["content_type"])
  end
  delegate :content_type, :extension, to: :mime

  # ActiveStorage のカラムを更新するとき用
  #  user.avatar.attach(io: DataUri.new(value).stream)
  def stream
    StringIO.new(to_blob)
  end

  def inspect
    "#<#{self.class.name} #{content_type} (#{to_blob.size} bytes)>"
  end

  private

  attr_accessor :body

  def parsed_attrs
    @parsed_attrs ||= yield_self do
      md = body.match(REGEXP_FORMAT)
      assert_data_uri_schema_format(md)
      md.named_captures
    end
  end

  def assert_data_uri_schema_format(md)
    unless md
      raise ArgumentError, "data URI scheme 形式になっていない : #{body.inspect.truncate(40)}"
    end
  end
end
