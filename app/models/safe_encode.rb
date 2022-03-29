module SafeEncode
  extend self

  def safe_encode(str, encoding)
    str.encode(encoding, :invalid => :replace, :replace => "（エンコードできない文字）")
  end
end
