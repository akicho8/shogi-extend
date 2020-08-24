# レーティングの計算
#
#   EloRating.rating_update1(1500, 1500) # => [1516, 1484]
#   EloRating.rating_update1(1500, 1100) # => [1503, 1097]
#
#  K = 32
#   ・同Rの場合、係数 0.5 になるので K(=32) * 0.5 = 16 の差で足し引きする
#   ・たとえば 1500 vs 1500 で勝った方は 1516 にる。負けた方は 1484 になる
#   ・ここで一度に変動する大きさが K とわかる
#   ・K を上げると収束が速いけど安定しない。趣味でやっている人向け。一喜一憂できる
#   ・K を下げると収束が遅いけど安定する。プロ向け
#
#  基準値 1500
#   ・1500 は係数に関係がないので、0を基準にしてもいい
#   ・けど、平均以下の人がマイナス表記になるのはかわいそうじゃね？ という配慮から底上げしている
#
#  400
#   ・1500 が 1100 に勝っても +3 しかRが上がらない。その値の調整ができる
#   ・R差 400 のとき 0.09  * 32 → 2.9
#   ・R差 700 のとき 0.01  * 32 → 0.5
#   ・R差 800 のとき 0.009 * 32 → 0.3
#   ・Rを「四捨五入しているとき」 0.3 は 0 になるので勝っても負けてもRが変動しなくなる
#   ・これは「四捨五入」しているのが問題で、Rを小数も含めるなら、Rは微差だけど変動する
#   ・変動しなくなるなら 400 のときはR差は 700 程度までにしようと考えることになる
#   ・どうせそれをするなら「擬似的な算出方法」が有用になる
#   ・正しい計算のメリット 1500 vs 0 で対戦してもレートが微差だけど変動する
#   ・対戦するR差に制限を入れるなら、メリットが少ない
#
#  擬似的な算出方法
#   ・単純に分母を 400 * 2 として (差 / 400*2) + 0.5 にする
#   ・差は単に引き算ではなく(負けた方 - 勝った方)とすること
#   ・R差399のとき 399.fdiv(400*2) + 0.5 → 0.99
#   ・R差400のとき 400.fdiv(400*2) + 0.5 → 1.0
#   ・R差401のとき 401.fdiv(400*2) + 0.5 → 1.001 ※Kを超えてしまう
#   ・R差400未満で対戦するときだけ使える
#
# experiment/elo_rating.rb
module Xclock
  module EloRating
    extend self

    class InvalidArgument < StandardError; end

    mattr_accessor(:rating_default) { 1500 }

    # https://ja.wikipedia.org/wiki/%E3%82%A4%E3%83%AD%E3%83%AC%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0
    # > Kは自由に設定できる定数値であり、一般的には32が採用されることが多いが、
    # > プロレベルでは16が使われることもある。Kが大きいほど、適正レーティングに収束するのが早くなる一方
    # > 収束した後も頻繁に上下する不安定な値となる
    K = 32

    mattr_accessor(:alpha) { 400 }

    mattr_accessor(:exception_enable) { true }

    # def plus_minus_retval(method, a, b)
    #   d = send(method, a, b)
    #   [d, -d]
    # end

    # 正しい方法
    def rating_update1(a, b)
      w = 1.fdiv(10**((a - b).fdiv(alpha)) + 1) # Wab は a - b
      K * w
    end

    # レートの変動を 1 以上に補正する
    def rating_update2(a, b)
      w = 1.fdiv(10**((a - b).fdiv(alpha)) + 1)
      d = K * w
      correcting_the_1_below_the_decimal_to_1_or_minus1(d)
    end

    # 擬似的な算出方法
    # ・R差400未満同士で対戦するときのみ使える
    def rating_update3(a, b)
      v = b - a
      w = v.fdiv(alpha*2) + 0.5
      d = K * w

      if exception_enable
        if v > alpha
          raise InvalidArgument, "R差#{v} > #{alpha} のとき加算値#{d}が#{K}を超える"
        end
        if v == -alpha
          raise InvalidArgument, "R差#{v} == -#{alpha} のとき加算値#{d}が0になる"
        end
        if v < -alpha
          raise InvalidArgument, "R差#{v} < -#{alpha} のとき加算値#{d}がマイナスになる"
        end
      end

      d
    end

    # 擬似的な算出方法補正入り
    # ・R差400以上で対戦するときに使える
    def rating_update4(a, b)
      v = b - a
      if v > alpha
        d = K           # 大金星だけどレートが上がりすぎるため 32 に補正する
      elsif v <= -alpha
        d = 1           # 弱すぎる人に勝ったときレートが下がるのを防ぐ
      else
        w = v.fdiv(alpha*2) + 0.5
        d = K * w
        d = correcting_the_1_below_the_decimal_to_1_or_minus1(d) # -0.9..0.9 -> -1.0..1.0
      end

      d
    end

    private

    # レート差 399 ぐらいでは K = 32 でも 1 以上にならないため -0.9..0.9 のような値を -1 か 1 に補正する
    # clamp の逆
    #    0.3 -->  1.0
    #   -0.3 --> -1.0
    def correcting_the_1_below_the_decimal_to_1_or_minus1(d)
      if d.zero?
        raise InvalidArgument, "d が 0"
      end

      v = d.abs                 # -0.3 -> 0.3
      if v < 1.0                # 0.3 < 1.0
        v = v.ceil              # 0.3 -> 1.0
        if d < 0                # -0.3 < 0
          d = -v                # -1.0
        else
          d = v
        end
      end
      d
    end
  end
end
