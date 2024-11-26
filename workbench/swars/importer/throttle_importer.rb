require "./setup"
Swars::Importer::ThrottleImporter.new(user_key: "bsplive").run
Swars::User["bsplive"].hard_crawled_at # => Tue, 26 Nov 2024 18:03:36.000000000 JST +09:00
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=bsplive
# >> bsplive P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=bsplive
# >> bsplive P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=bsplive
# >> bsplive P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
