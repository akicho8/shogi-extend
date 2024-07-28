require "./setup"
Swars::CrawlReservation.destroy_all
current_user = User.admin
json = QuickScript::Swars::AllDownloadScript.new({user_key: "alice", attachment_mode: "with_zip"}, {_method: "post", current_user: current_user}).as_json
json[:flash][:notice]                   # => "予約しました"
crawl_reservation = Swars::CrawlReservation.last
crawl_reservation.crawl!
crawl_reservation.reload
p crawl_reservation.processed_at


# Swars::Crawler::ReservationCrawler.new.run
# tp Swars::CrawlReservation

# >> |------+---------+-----------------+-----------------+--------------+---------------------------+---------------------------|
# >> | id   | user_id | target_user_key | attachment_mode | processed_at | created_at                | updated_at                |
# >> |------+---------+-----------------+-----------------+--------------+---------------------------+---------------------------|
# >> | 4364 |      36 | alice           | with_zip        |              | 2024-07-28 20:54:51 +0900 | 2024-07-28 20:54:51 +0900 |
# >> |------+---------+-----------------+-----------------+--------------+---------------------------+---------------------------|
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:78", :crawl!]
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=alice
# >> alice P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=alice
# >> alice P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=alice
# >> alice P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:80", :crawl!]
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:83", :crawl!]
# >> |--------------+---|
# >> | before_count | 1 |
# >> |  after_count | 1 |
# >> |   diff_count | 0 |
# >> |--------------+---|
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:85", :crawl!]
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:88", :crawl!]
# >> 2024-07-28T11:54:52.031Z pid=49037 tid=xf5 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> ["/Users/ikeda/src/shogi-extend/app/models/swars/crawl_reservation.rb:90", :crawl!]
# >> |--------+------|
# >> | notify | true |
# >> |  sleep | 0    |
# >> |--------+------|
# >> |---------------------+--------+------------+------+----+----+------+----------+----------+-------------------------------+--------|
# >> | 日時                | ID     | ユーザー名 | 段級 | 前 | 後 | 差分 | 検索回数 | 最終検索 | 最終対局                      | エラー |
# >> |---------------------+--------+------------+------+----+----+------+----------+----------+-------------------------------+--------|
# >> | 2024-07-28 20:54:51 | 967063 | alice      | 30級 |  1 |  1 |   +0 |        0 |          | 2024-07-21 14:41 (7/21 14:41) |        |
# >> |---------------------+--------+------------+------+----+----+------+----------+----------+-------------------------------+--------|
# >> |------+---------+-----------------+-----------------+---------------------------+---------------------------+---------------------------|
# >> | id   | user_id | target_user_key | attachment_mode | processed_at              | created_at                | updated_at                |
# >> |------+---------+-----------------+-----------------+---------------------------+---------------------------+---------------------------|
# >> | 4364 |      36 | alice           | with_zip        | 2024-07-28 20:54:51 +0900 | 2024-07-28 20:54:51 +0900 | 2024-07-28 20:54:51 +0900 |
# >> |------+---------+-----------------+-----------------+---------------------------+---------------------------+---------------------------|
