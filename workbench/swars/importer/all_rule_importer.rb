require "./setup"
Swars::Importer::AllRuleImporter.new(user_key: "bsplive", early_break: true).run
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=bsplive
# >> bsplive P1 10分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=bsplive
# >> bsplive P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=bsplive
# >> bsplive P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
