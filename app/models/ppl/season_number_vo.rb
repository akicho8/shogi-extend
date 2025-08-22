module Ppl
  SeasonNumberVo = Data.define(:number) do
    def initialize(...)
      super

      unless number.kind_of? Integer
        raise ArgumentError, number.inspect
      end
    end

    def to_i
      number
    end

    def to_s
      number.to_s
    end

    def spider
      [OfficialSpider, UnofficialSpider].find { |e| e.accept_season_number_range.cover?(number) }
    end
  end
end
