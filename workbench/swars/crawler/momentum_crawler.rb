require "./setup"
user = Swars::User.create!
user.search_logs.create!
instance = Swars::Crawler::MomentumCrawler.new(period: 100.days, at_least: 1, limit: 2)
Swars::Battle.count                    # => 1895517
instance.run
Swars::Battle.count                    # => 1895517
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=sinkensi
# >> sinkensi P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=sinkensi
# >> sinkensi P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=sinkensi
# >> sinkensi P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=raminitk
# >> raminitk P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=raminitk
# >> raminitk P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=raminitk
# >> raminitk P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> 2024-11-07T12:09:27.433Z pid=90465 tid=227l INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |-------------+----------------------------------|
# >> |      notify | true                             |
# >> |       sleep | 0                                |
# >> |     subject | 直近数日で注目されているユーザー |
# >> |    page_max | 1                                |
# >> | early_break | false                            |
# >> |      period | 8640000                          |
# >> |    at_least | 1                                |
# >> |       limit | 2                                |
# >> |-------------+----------------------------------|
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+--------------------------------+--------|
# >> | 日時                | ID     | ユーザー名 | 段級 | 前  | 後  | 差分 | 検索回数 | 最終検索   | 最終対局                       | エラー |
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+--------------------------------+--------|
# >> | 2024-11-07 21:09:27 |    169 | sinkensi   | 四段 | 102 | 102 |   +0 |       19 | 9/30 19:03 | 2024-10-17 14:25 (10/17 14:25) |        |
# >> | 2024-11-07 21:09:27 | 135378 | raminitk   | 初段 | 104 | 104 |   +0 |       14 | 9/13 00:28 | 2024-10-17 22:09 (10/17 22:09) |        |
# >> |---------------------+--------+------------+------+-----+-----+------+----------+------------+--------------------------------+--------|
