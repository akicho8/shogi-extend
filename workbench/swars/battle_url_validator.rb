require "#{__dir__}/setup"
url = "https://shogiwars.heroz.jp/games/Kato_Hifumi-SiroChannel-20200927_180900"
Swars::BattleUrlValidator.valid?(url)              # => true
Swars::BattleUrlValidator.invalid?("_#{url}")      # => true
Swars::BattleUrlValidator.validate!("_") rescue $! # => #<Swars::InvalidKey: 将棋ウォーズの対局URLではありません : "_">
