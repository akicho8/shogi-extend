require "#{__dir__}/setup"
Swars::BattleKeyValidator.valid?("Kato_Hifumi-SiroChannel-20190317_140844") # => true

Swars::BattleKeyValidator::REGEXP # => /(?-mix:\b[a-zA-Z][a-zA-Z_]{2,14}\b)-(?-mix:\b[a-zA-Z][a-zA-Z_]{2,14}\b)-(?-mix:\b\d{8}_\d{6}\b)/
