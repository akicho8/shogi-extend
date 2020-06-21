require "memory_record"
require "active_support/core_ext/array"

class UdemaeInfo
  include MemoryRecord
  memory_record [
    { key: "C-", win: 20, lose: 10, },
    { key: "C",  win: 15, lose: 10, },
    { key: "C+", win: 12, lose: 10, },
    { key: "B-", win: 10, lose: 10, },
    { key: "B",  win: 10, lose: 10, },
    { key: "B+", win: 10, lose: 10, },
    { key: "A-", win: 10, lose: 10, },
    { key: "A",  win: 10, lose: 10, },
    { key: "A+", win: 10, lose: 10, },
    { key: "S",  win:  5, lose:  6, },
    { key: "S+", win:  4, lose:  4, },
  ]
end

def elo_rating_diff(a, b)
  k = 32
  wab = 1.fdiv(10**((a - b).fdiv(400)) + 1.0)
  wab                     # => 0.5, 0.5
  k * wab                 # => 16.0, 16.0
end
elo_rating_diff(1500, 1500)    # => 16.0

class User
  attr_accessor :udemae_key
  attr_accessor :rating
  attr_accessor :point

  def initialize
    @udemae_key = "C-"
    @rating = 1500
    @point = 0
  end

  def add(point_plus)
    v = point + point_plus
    rdiff, rest = v.divmod(100)

    if rdiff.nonzero?
      udemae_info = UdemaeInfo.fetch(udemae_key)
      new_udemae_info = UdemaeInfo[udemae_info.code + rdiff]
      if new_udemae_info
        self.udemae_key = new_udemae_info.key
        self.point = rest
      else
        self.point = v.clamp(0, 100)
      end
    else
      self.point = v
    end
  end
end

user1 = User.new
user2 = User.new

diff = elo_rating_diff(user1.rating, user2.rating) # => 16.0
user1.rating + diff                               # => 1516.0
user2.rating - diff                               # => 1484.0

info = UdemaeInfo.fetch(user1.udemae_key)
# 同じレートで勝ったら+16(Kの半分)になってそのときウデマエ+20としたいので係数は「設定値/16」とする
# これで 16 * 係数 で 20 になる
16 * (20 / 16.0)                       # => 20.0

# なので勝ち負け両方の加減算ポイントを計算
win  = diff * info[:win].fdiv(16)      # => 20.0
lose = diff * info[:lose].fdiv(16)     # => 10.0

user1.point + win                     # => 20.0
user2.point - lose                    # => -10.0

def test1(user, udemae_key, point, diff)
  user.udemae_key = udemae_key
  user.point = point
  user.add(diff)
  [user.udemae_key, user.point]
end

# 上昇
test1(user1, "C-",  98, 1)   # => ["C-", 99]
test1(user1, "C-",  98, 2)   # => [:C, 0]
test1(user1, "C-",  98, 3)   # => [:C, 1]
# 上昇(飛び級)
test1(user1, "C-",  98, 101) # => [:C, 99]
test1(user1, "C-",  98, 102) # => [:"C+", 0]
test1(user1, "C-",  98, 103) # => [:"C+", 1]
# 下降
test1(user1, "C+",  2, -1)   # => ["C+", 1]
test1(user1, "C+",  2, -2)   # => ["C+", 0]
test1(user1, "C+",  2, -3)   # => [:C, 99]
# 下降(飛び級)
test1(user1, "C+",  2, -101) # => [:C, 1]
test1(user1, "C+",  2, -102) # => [:C, 0]
test1(user1, "C+",  2, -103) # => [:"C-", 99]
# 限界(上)
test1(user1, "S+", 98, 1)    # => ["S+", 99]
test1(user1, "S+", 98, 2)    # => ["S+", 100]
test1(user1, "S+", 98, 3)    # => ["S+", 100]
# 限界(下)
test1(user1, "C-",  2, -1)   # => ["C-", 1]
test1(user1, "C-",  2, -2)   # => ["C-", 0]
test1(user1, "C-",  2, -3)   # => ["C-", 0]
