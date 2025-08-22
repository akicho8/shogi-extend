require "#{__dir__}/setup"
Ppl::SeasonNumberVo[30].spider # => Ppl::UnofficialSpider
Ppl::SeasonNumberVo[31].spider # => Ppl::OfficialSpider
