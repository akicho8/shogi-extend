require "#{__dir__}/setup"
url = "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900"
Swars::BattleUrlExtractor.extract(url) # => #<Swars::BattleUrl:0x000000012073fd40 @url="https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900">
