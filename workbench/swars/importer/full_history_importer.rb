require "./setup"
# Swars::Importer::FullHistoryImporter.new(user_key: "bsplive").call
# Swars::User["bsplive"].hard_crawled_at # => Tue, 26 Nov 2024 18:17:42.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "th_1230", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["th_1230"].hard_crawled_at # => Wed, 27 Nov 2024 07:43:49.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "yukky1119", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["yukky1119"].hard_crawled_at # => Sun, 24 Nov 2024 14:14:45.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "slowstep3210", remote_run: true, look_up_to_page_x: 1).call
# Swars::User["slowstep3210"].hard_crawled_at # => Sun, 24 Nov 2024 01:26:58.000000000 JST +09:00

Swars::Importer::FullHistoryImporter.new(user_key: "akihiko810", remote_run: true, look_up_to_page_x: 1).call
Swars::User["akihiko810"].hard_crawled_at # => Sat, 23 Nov 2024 01:12:46.000000000 JST +09:00

# Swars::Importer::FullHistoryImporter.new(user_key: "Myan_yade", remote_run: true, look_up_to_page_x: 1).call

# tp Swars::User["asa2yoru"].battles.last(10).collect(&:info)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 Page1 10分 [全10件][新0件][続く]
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 Page1 3分 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=akihiko810
# >> akihiko810 Page1 10秒 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 Page1 10分 [全10件][新0件][続く]
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 Page1 3分 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=akihiko810
# >> akihiko810 Page1 10秒 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=akihiko810
# >> akihiko810 Page1 10分 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 Page1 10分 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 Page1 3分 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=akihiko810
# >> akihiko810 Page1 10秒 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=akihiko810
# >> akihiko810 Page1 ルール未指定 [全0件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
