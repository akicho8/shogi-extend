# 検索向けの日付指定を範囲に変換する
#
#   DateRange.parse("2000-01-01")              # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
#   DateRange.parse("2000-01")                 # => 2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900
#   DateRange.parse("2000")                    # => 2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900
#
#   DateRange.parse("2000-01-01..2000-01-01")  # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
#   DateRange.parse("2000-01-01...2000-01-02") # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
#   DateRange.parse("2000..2001")              # => 2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900
#   DateRange.parse("2000...2002")             # => 2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900
#   DateRange.parse("2000...")                 # => 2000-01-01 00:00:00 +0900...9999-01-01 00:00:00 +0900
#   DateRange.parse("...2000")                 # => 1000-01-01 00:00:00 +0900...2000-01-01 00:00:00 +0900
#
class DateRange
  # https://dev.mysql.com/doc/refman/5.6/ja/datetime.html
  DATE_YEAR_MIN = "1000"
  DATE_YEAR_MAX = "9999"

  class << self
    def parse(source)
      new(source).to_range
    end
  end

  attr_accessor :source

  def initialize(source)
    @source = source
  end

  # 何が来ても終端を含まない Range 型にする
  def to_range
    s = normalize(@source)
    if range_type?
      a, b = s.split(/\.{2,3}/).collect(&:presence)
      a ||= "#{DATE_YEAR_MIN}-01-01"
      b ||= "#{DATE_YEAR_MAX}-01-01"
      ab = [a, b].collect { |e| Ymd.new(*ymd_scan(e)) }
      if !ab.all?(&:valid?)
        raise ArgumentError, @source.inspect
      end
      a, b = ab
      if exclude_end_type?
        a.to_time...b.to_time
      else
        a.to_time...b.to_time_next
      end
    else
      v = Ymd.new(*ymd_scan(s))
      if !v.valid?
        raise ArgumentError, @source.inspect
      end
      v.to_range
    end
  end

  private

  def ymd_scan(str)
    str.scan(/\d+/).collect(&:to_i)
  end

  def normalize(str)
    str.tr("０-９", "0-9")
  end

  def range_type?
    @source.include?("..")
  end

  def exclude_end_type?
    @source.include?("...")
  end

  class Ymd
    attr_accessor :y, :m, :d

    def initialize(*args)
      @y, @m, @d = *args
    end

    def valid?
      y
    end

    def to_time
      Time.new(y, m || 1, d || 1)
    end

    def to_time_next
      to_time.public_send(next_method)
    end

    def to_range
      to_time...to_time_next
    end

    private

    def next_method
      case
      when y && m && d
        :tomorrow
      when y && m
        :next_month
      when y
        :next_year
      else
        raise "must not happen"
      end
    end
  end
end

if $0 == __FILE__
  require "active_support/all"

  DateRange.parse("2000-01-01")              # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
  DateRange.parse("2000-01")                 # => 2000-01-01 00:00:00 +0900...2000-02-01 00:00:00 +0900
  DateRange.parse("2000")                    # => 2000-01-01 00:00:00 +0900...2001-01-01 00:00:00 +0900
  DateRange.parse("") rescue $!              # => #<ArgumentError: "">
  DateRange.parse("xx") rescue $!            # => #<ArgumentError: "xx">

  DateRange.parse("2000-01-01..2000-01-01")  # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
  DateRange.parse("2000-01-01...2000-01-02") # => 2000-01-01 00:00:00 +0900...2000-01-02 00:00:00 +0900
  DateRange.parse("2000..2001")              # => 2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900
  DateRange.parse("2000...2002")             # => 2000-01-01 00:00:00 +0900...2002-01-01 00:00:00 +0900
  DateRange.parse("2000...")                 # => 2000-01-01 00:00:00 +0900...9999-01-01 00:00:00 +0900
  DateRange.parse("...2000")                 # => 1000-01-01 00:00:00 +0900...2000-01-01 00:00:00 +0900
end
