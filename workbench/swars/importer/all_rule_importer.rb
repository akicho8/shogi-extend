require "./setup"
# Swars::Importer::AllRuleImporter.new(user_key: "bsplive").run
# Swars::User["bsplive"].hard_crawled_at # => Tue, 26 Nov 2024 18:17:42.000000000 JST +09:00

Swars::Importer::AllRuleImporter.new(user_key: "th_1230", remote_run: true, page_max: 1).run
Swars::User["th_1230"].hard_crawled_at # => Wed, 27 Nov 2024 07:43:49.000000000 JST +09:00
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=th_1230
# >> th_1230 P1 10分 [全10件][新9件][続く]
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-skullna-20241225_224230
# >> [fetch][record] https://shogiwars.heroz.jp/games/KKKRRRYYY-th_1230-20241225_205830
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-kamishiro_san-20241225_193834
# >> [fetch][record] https://shogiwars.heroz.jp/games/hiro8305-th_1230-20241225_123027
# >> [fetch][record] https://shogiwars.heroz.jp/games/knzGISH-th_1230-20241225_080208
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-pideto-20241225_075318
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-kingdomon-20241224_224838
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-youstate-20241224_222129
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-minarai610MVP17-20241224_214509
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=th_1230
# >> th_1230 P1 3分 [全2件][新2件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][record] https://shogiwars.heroz.jp/games/th_1230-hitoribotti0711-20241224_131849
# >> [fetch][record] https://shogiwars.heroz.jp/games/Houndtruth17-th_1230-20241211_075119
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=th_1230
# >> th_1230 P1 10秒 [全0件][新0件][最後]
# >> 最後のページと思われるので終わる
