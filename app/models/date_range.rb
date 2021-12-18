module DateRange
  extend self

  def parse(str)
    range = Chronic.parse(str, guess: false)
    # NOTE: なぜか終端が1秒進みすぎているため1秒戻す
    # 今の状態だと range は range.first..range.last となっている
    range.first...range.last
  end
end
