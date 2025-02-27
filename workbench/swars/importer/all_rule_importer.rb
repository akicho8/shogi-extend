require "./setup"
# Swars::Importer::AllRuleImporter.new(user_key: "bsplive").call
# Swars::User["bsplive"].hard_crawled_at # => Tue, 26 Nov 2024 18:17:42.000000000 JST +09:00

# Swars::Importer::AllRuleImporter.new(user_key: "th_1230", remote_run: true, page_max: 1).call
# Swars::User["th_1230"].hard_crawled_at # => Wed, 27 Nov 2024 07:43:49.000000000 JST +09:00

# Swars::Importer::AllRuleImporter.new(user_key: "yukky1119", remote_run: true, page_max: 1).call
# Swars::User["yukky1119"].hard_crawled_at # => Sun, 24 Nov 2024 14:14:45.000000000 JST +09:00

# Swars::Importer::AllRuleImporter.new(user_key: "slowstep3210", remote_run: true, page_max: 1).call
# Swars::User["slowstep3210"].hard_crawled_at # => Sun, 24 Nov 2024 01:26:58.000000000 JST +09:00

Swars::Importer::AllRuleImporter.new(user_key: "akihiko810", remote_run: true, page_max: 1).run
Swars::User["akihiko810"].hard_crawled_at # => Sat, 23 Nov 2024 01:12:46.000000000 JST +09:00

# tp Swars::User["asa2yoru"].battles.last(10).collect(&:info)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&init_pos_type=normal&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 P1 10分 [全10件][新10件][続く]
# >> [fetch][record] https://shogiwars.heroz.jp/games/don5200-akihiko810-20250223_002913
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-Bouyatatsu_Lion-20250223_002313
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-qpwo-20250223_001402
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-kairoyama-20250220_235944
# >> [fetch][record] https://shogiwars.heroz.jp/games/KAIHEN-akihiko810-20250220_234427
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-shingo4068-20250220_233201
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-Urig-20250220_003701
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-tanaka_kero-20250220_002430
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-gonfoxx-20250220_001424
# >> [fetch][record] https://shogiwars.heroz.jp/games/satoyan0318Boy-akihiko810-20250217_000324
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&init_pos_type=normal&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 P1 3分 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&init_pos_type=normal&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 P1 10秒 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&init_pos_type=normal&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 P1 10分 [全10件][新10件][続く]
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-ssympaty-20250227_225618
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-ssympaty-20250227_224922
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-hide_yuki_kun-20250227_222503
# >> [fetch][record] https://shogiwars.heroz.jp/games/hide_yuki_kun-akihiko810-20250227_220259
# >> [fetch][record] https://shogiwars.heroz.jp/games/hide_yuki_kun-akihiko810-20250227_215809
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-suneko222-20250227_203704
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-ssympaty-20250223_223144
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-ssympaty-20250223_221151
# >> [fetch][record] https://shogiwars.heroz.jp/games/akihiko810-ssympaty-20250223_220115
# >> [fetch][record] https://shogiwars.heroz.jp/games/ssympaty-akihiko810-20250223_213922
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&init_pos_type=normal&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 P1 3分 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&init_pos_type=normal&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 P1 10秒 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&init_pos_type=normal&opponent_type=coach&page=1&user_id=akihiko810
# >> akihiko810 P1 10分 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&init_pos_type=normal&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 P1 10分 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&init_pos_type=normal&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 P1 3分 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&init_pos_type=normal&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 P1 10秒 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&init_pos_type=sprint&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 P1 ルール未指定 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
