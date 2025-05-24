require "#{__dir__}/setup"
Swars::BattleKeyValidator.valid?("Kato_Hifumi-SiroChannel-20190317_140844") # => true
Swars::BattleKeyValidator.valid?("DevUser1-YamadaTaro-20200101_123401")     # => true
Swars::BattleKeyValidator::REGEXP # => 
# ~> -:4:in '<main>': uninitialized constant Swars::BattleKeyValidator::REGEXP (NameError)
# ~> Did you mean?  Regexp
