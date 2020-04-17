module Acns2
  module EloRating
    extend self

    mattr_accessor(:rating_default) { 1500 }

    # https://ja.wikipedia.org/wiki/%E3%82%A4%E3%83%AD%E3%83%AC%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0
    # > Kは自由に設定できる定数値であり、一般的には32が採用されることが多いが、
    # > プロレベルでは16が使われることもある。Kが大きいほど、適正レーティングに収束するのが早くなる一方
    # > 収束した後も頻繁に上下する不安定な値となる
    mattr_accessor(:k) { 32 }

    def rating_update(a, b)
      w = 1.fdiv(10**((a - b).fdiv(400)) + 1)
      d = (k * w).round
      [
        a + d,
        b - d,
      ]
    end
  end
end
