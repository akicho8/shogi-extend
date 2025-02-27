require "./setup"
# ENV["EXECUTE_ERROR_PURPOSE"] = "1"
user = Swars::User.create!
user.search_logs.create!
instance = Swars::Crawler::MomentumCrawler.new(period: 100.days, at_least: 1, limit: 2)
Swars::Battle.count                    # => 1895538
instance.call
Swars::Battle.count                    # => 1895538
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=raminitk
# >> raminitk P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=raminitk
# >> raminitk P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=raminitk
# >> raminitk P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=abc
# >> abc P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=abc
# >> abc P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=abc
# >> abc P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> 2024-12-05T00:40:24.306Z pid=95055 tid=1yn3 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> "[将棋ウォーズ][クロール完了][直近数日で注目されているユーザー] +0"
# >> |------------------+----------------------------------|
# >> |           notify | true                             |
# >> |            sleep | 0                                |
# >> |          subject | 直近数日で注目されているユーザー |
# >> |         page_max | 1                                |
# >> |       hard_crawl | true                             |
# >> |           period | 8640000                          |
# >> |         at_least | 1                                |
# >> |            limit | 2                                |
# >> | hard_crawled_old | 259200                           |
# >> |------------------+----------------------------------|
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+---------------------+---------------------+--------|
# >> | 日時                | ID     | ユーザー名 | 段級 | 前  | 後  | 差分 | 検索回数 | 最終検索   | 最終対局            | 全クロール          | エラー |
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+---------------------+---------------------+--------|
# >> | 2024-12-05 09:40:24 | 135378 | raminitk   | 初段 | 104 | 104 |   +0 |       14 | 9/13 00:28 | 2024-10-17 22:09:05 | 2024-11-22 19:57:08 |        |
# >> | 2024-12-05 09:40:24 | 181315 | abc        | 1級  |   1 |   1 |   +0 |        8 | 9/29 13:59 | 2024-07-06 15:53:28 | 2024-11-22 19:57:08 |        |
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+---------------------+---------------------+--------|
