require "./setup"
# ENV["EXECUTE_ERROR_PURPOSE"] = "1"
user = Swars::User.create!
user.search_logs.create!
instance = Swars::Crawler::SemiActiveUserCrawler.new(period: 100.days, at_least: 1, limit: 2)
Swars::Battle.count                    # => 1973612
instance.call
Swars::Battle.count                    # => 1973612
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=Houndtruth17
# >> Houndtruth17 Page1 ルール未指定 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=gon12121212
# >> gon12121212 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=gon12121212
# >> gon12121212 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=gon12121212
# >> gon12121212 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=gon12121212
# >> gon12121212 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=gon12121212
# >> gon12121212 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=gon12121212
# >> gon12121212 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=gon12121212
# >> gon12121212 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=gon12121212
# >> gon12121212 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=gon12121212
# >> gon12121212 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=gon12121212
# >> gon12121212 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=gon12121212
# >> gon12121212 Page1 ルール未指定 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> 2025-03-01T08:52:33.755Z pid=25751 tid=mlv INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> "[将棋ウォーズ][クロール完了][直近数日で注目されているユーザー] +0"
# >> |------------------+----------------------------------|
# >> |           notify | true                             |
# >> |            sleep | 0                                |
# >> |          subject | 直近数日で注目されているユーザー |
# >> |           period | 8640000                          |
# >> |         at_least | 1                                |
# >> |            limit | 2                                |
# >> | hard_crawled_old | 259200                           |
# >> |------------------+----------------------------------|
# >> |---------------------+---------+--------------+------+----+----+------+----------+------------------+---------------------+---------------------+--------|
# >> | 日時                | ID      | ユーザー名   | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索         | 最終対局            | 全クロール          | エラー |
# >> |---------------------+---------+--------------+------+----+----+------+----------+------------------+---------------------+---------------------+--------|
# >> | 2025-03-01 17:52:33 |  860057 | Houndtruth17 | 初段 |  9 |  9 |   +0 |        2 | 2024-11-22 11:17 | 2025-01-18 09:10:41 | 2024-11-23 10:00:22 |        |
# >> | 2025-03-01 17:52:33 | 1011689 | gon12121212  | 30級 |  0 |  0 |   +0 |       31 |                  |                     | 2024-10-18 12:54:29 |        |
# >> |---------------------+---------+--------------+------+----+----+------+----------+------------------+---------------------+---------------------+--------|
