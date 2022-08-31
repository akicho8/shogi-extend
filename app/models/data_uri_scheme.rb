# フロント側の Data URI Scheme 形式のバイナリ化
#
#  body = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAIAQMAAAD+wSzIAAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JgAAgIQAAPoAAACA6AAAdTAAAOpgAAA6mAAAF3CculE8AAAABlBMVEUAAP////973JksAAAAAWJLR0QB/wIt3gAAAAd0SU1FB+YIHwktKVmKpzsAAAALSURBVAjXY2BABQAAEAABocUhwQAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMi0wOC0zMVQwOTo0NTo0MSswMDowMCXHz4IAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjItMDgtMzFUMDk6NDU6NDErMDA6MDBUmnc+AAAAAElFTkSuQmCC"
#  object = DataUriScheme.new(body)
#  object.binary       # => "..."
#  object.read         # => "..."
#  object.content_type # => "image/png"
#
require "base64"

class DataUriScheme
  REGEXP_FORMAT = /\A(?:data):(?<content_type>.*?);base64,(?<base64_text>.*)/

  def initialize(body)
    @body = body
  end

  def binary
    # https://docs.ruby-lang.org/ja/latest/class/Base64.html
    @binary ||= Base64.decode64(parsed_attrs["base64_text"])
  end

  def read
    binary
  end

  def mime
    @mime ||= MiniMime.lookup_by_content_type(parsed_attrs["content_type"])
  end

  def content_type
    mime.content_type
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
