# 英数字を使った短かいハッシュを返す

module ShortUrl
  module AlnumHash
    extend self

    HEX_LENGTH = 16
    CHARS = [*"a".."z", *"A".."Z", *"0".."9"]

    def call(url)
      hex = Digest::MD5.hexdigest(url)
      hex = hex[...HEX_LENGTH]
      v = hex.to_i(16)
      a = []
      while v > 0
        v, r = v.divmod(CHARS.size)
        a << CHARS[r]
      end
      a.join
    end
  end
end
