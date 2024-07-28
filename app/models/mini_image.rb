# インライン画像生成
#
# MiniImage.generate                                                  # => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABAQMAAAAl21bKAAAAA1BMVEUAAP+KeNJXAAAACklEQVQI12NgAAAAAgAB4iG8MwAAAABJRU5ErkJggg=="
# MiniImage.generate(format: :bmp)                                    # => "data:image/bmp;base64,Qk2OAAAAAAAAAIoAAAB8AAAAAQAAAAEAAAABABgAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAD/AAD/AAD/AAAAAAAA/0JHUnOPwvUoUbgeFR6F6wEzMzMTZmZmJmZmZgaZmZkJPQrXAyhcjzIAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAA/wAAAA=="
# MiniImage.generate(format: :jpg)                                    # => "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAABAAEDAREAAhEBAxEB/8QAFAABAAAAAAAAAAAAAAAAAAAACf/EABQQAQAAAAAAAAAAAAAAAAAAAAD/xAAVAQEBAAAAAAAAAAAAAAAAAAAGCf/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/AD3VTB3/2Q=="
# MiniImage.generate(width: 1, height: 1, color: "red", format: :jpg) # => "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAABAAEDAREAAhEBAxEB/8QAFAABAAAAAAAAAAAAAAAAAAAACP/EABQQAQAAAAAAAAAAAAAAAAAAAAD/xAAVAQEBAAAAAAAAAAAAAAAAAAAHCf/EABQRAQAAAAAAAAAAAAAAAAAAAAD/2gAMAwEAAhEDEQA/ADoDFU3/2Q=="
#
require "base64"

class MiniImage
  class << self
    def generate(...)
      new(...).to_s
    end
  end

  def initialize(options = {})
    @options = {
      :width  => 1,
      :height => 1,
      :color  => "blue",
      :format => "png",
    }.merge(options)
  end

  def to_s
    "data:#{mime.content_type};base64,#{Base64.strict_encode64(binary)}"
  end

  private

  def binary
    if defined? Magick
      image = Magick::Image.new(*size) { |e| e.background_color = color }
      image.format = ext_name
      image.strip!
      image.to_blob
    else
      `convert -strip -size #{size.join("x")} xc:#{color} #{ext_name}:-`
    end
  end

  def mime
    MiniMime.lookup_by_extension(ext_name) or raise ArgumentError, "ext_name: #{ext_name.inspect}"
  end

  def color
    @options[:color].to_s
  end

  def size
    [@options[:width], @options[:height]]
  end

  def ext_name
    @options[:format].to_s
  end
end
