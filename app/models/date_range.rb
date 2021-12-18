# 検索向けの日付指定を範囲に変換する
#
#   DateRange.parse("2000-01-01")    # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
#   DateRange.parse("2000-01")       # => 2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900
#   DateRange.parse("2000")          # => 2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900
#
module DateRange
  extend self

  def parse(str)
    s = str.to_s
    s = s.tr("０-９", "0-9")
    y, m, d = s.scan(/\d+/).collect(&:to_i)
    case
    when y && m && d
      next_method = :tomorrow
    when y && m
      next_method = :next_month
    when y
      next_method = :next_year
    else
      raise ArgumentError, str.inspect
    end
    t = Time.new(y, m || 1, d || 1)
    t...t.public_send(next_method)
  end
end

if $0 == __FILE__
  require "active_support/all"
  DateRange.parse("2000-01-01")    # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
  DateRange.parse("2000-01")       # => 2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900
  DateRange.parse("2000")          # => 2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900
  DateRange.parse("") rescue $!    # => #<ArgumentError: "">
  DateRange.parse("xx") rescue $!  # => #<ArgumentError: "xx">
  DateRange.parse(nil) rescue $!   # => #<ArgumentError: nil>
end
