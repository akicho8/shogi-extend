require "./setup"
BattleKeyGenerator.new.generate              # => <alice-bob-20000101_000000>
BattleKeyGenerator.new(seed: 0).generate     # => <alice-bob-20000101_000000>
BattleKeyGenerator.new(seed: 1).generate     # => <alice-bob-20000101_000001>
