require "./setup"

Swars::Importer::FullHistoryImporter.new(user_key: "DevUser1").call
Swars::Battle.count             # => 1895517

puts Swars::Crawler::NotableCrawler.new.call.rows.to_t
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=DevUser1
# >> DevUser1 P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=DevUser1
# >> DevUser1 P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=DevUser1
# >> DevUser1 P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=DevUser1
# >> DevUser1 P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=DevUser1
# >> DevUser1 P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=DevUser1
# >> DevUser1 P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> 2024-11-14T04:55:32.521Z pid=40221 tid=rm5 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> |-------------+--------------------|
# >> |      notify | true               |
# >> |       sleep | 0                  |
# >> |     subject | 活動的なプレイヤー |
# >> |   user_keys | ["DevUser1"]       |
# >> |    look_up_to_page_x | 1                  |
# >> | hard_crawl | true               |
# >> |-------------+--------------------|
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
# >> | 日時                | ID      | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局            | エラー |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
# >> | 2024-11-14 13:55:32 | 1011688 | DevUser1   | 30級 |  1 |  1 |   +0 |        0 |          | 2020-01-01 12:34:01 |        |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
# >> | 日時                | ID      | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局            | エラー |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
# >> | 2024-11-14 13:55:32 | 1011688 | DevUser1   | 30級 |  1 |  1 |   +0 |        0 |          | 2020-01-01 12:34:01 |        |
# >> |---------------------+---------+------------+------+----+----+------+----------+----------+---------------------+--------|
