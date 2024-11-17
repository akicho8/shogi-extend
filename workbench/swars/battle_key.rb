require "./setup"
battle_key = Swars::BattleKey["alice-bob-20130531_010024"]
battle_key.to_s                 # => "alice-bob-20130531_010024"
battle_key.official_url         # => "https://shogiwars.heroz.jp/games/alice-bob-20130531_010024"
battle_key.inside_show_url      # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024"
battle_key.kento_url            # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024/kento"
battle_key.piyo_shogi_url       # => "http://localhost:4000/swars/battles/alice-bob-20130531_010024/piyo_shogi"
battle_key.search_url           # => "http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/alice-bob-20130531_010024"
battle_key.to_time              # => Fri, 31 May 2013 01:00:24.000000000 JST +09:00
battle_key.user_keys            # => [<alice>, <bob>]
battle_key.user_key_at(:white)  # => <bob>
