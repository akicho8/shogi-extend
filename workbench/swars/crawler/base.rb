require "./setup"

Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call
Swars::Battle.count             # => 1973612

puts Swars::Crawler::MainActiveUserCrawler.new.call.rows.to_t
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=DevUser1
# >> DevUser1 Page1 ルール未指定 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=DevUser1
# >> DevUser1 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=DevUser1
# >> DevUser1 Page1 ルール未指定 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> 2025-03-01T08:53:59.643Z pid=26514 tid=meu INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> "[将棋ウォーズ][クロール完了][活動的なプレイヤー] +0"
# >> |-------------------+--------------------|
# >> |            notify | true               |
# >> |             sleep | 0                  |
# >> |           subject | 活動的なプレイヤー |
# >> |         user_keys | ["DevUser1"]       |
# >> | look_up_to_page_x | 1                  |
# >> |-------------------+--------------------|
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
# >> | 日時                | ID      | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局            | 全クロール          | エラー |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
# >> | 2025-03-01 17:53:59 | 1040585 | DevUser1   | 30級 |  1 |  1 |   +0 |        0 |          | 2020-01-01 12:34:01 | 2025-01-22 19:38:08 |        |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
# >> | 日時                | ID      | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局            | 全クロール          | エラー |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
# >> | 2025-03-01 17:53:59 | 1040585 | DevUser1   | 30級 |  1 |  1 |   +0 |        0 |          | 2020-01-01 12:34:01 | 2025-01-22 19:38:08 |        |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+---------------------+--------|
