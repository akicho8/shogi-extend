module SafeSfen
  extend self

  def encode(sfen)
    Base64.urlsafe_encode64(sfen, padding: false)
  end

  # KI2の場合を考慮してUTF-8化する
  # UTF-8 化しないと Encoding::CompatibilityError (incompatible character encodings: ASCII-8BIT and UTF-8) になる
  def decode(bin)
    Base64.urlsafe_decode64(bin).toutf8
  end
end
