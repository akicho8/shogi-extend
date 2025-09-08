require "#{__dir__}/setup"
Swars::BattleKeyValidator.valid?("Kato_Hifumi-SiroChannel-20190317_140844") # => true
Swars::BattleKeyValidator.valid?("DevUser1-YamadaTaro-20200101_123401")     # => true
Swars::BattleKeyValidator.regexp # => /(?-mix:\b[a-zA-Z\d][a-zA-Z\d_]{2,32}\b)-(?-mix:\b[a-zA-Z\d][a-zA-Z\d_]{2,32}\b)-(?-mix:\b\d{8}_\d{6}\b)/
