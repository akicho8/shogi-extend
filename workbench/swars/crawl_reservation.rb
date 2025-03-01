require "../setup"
admin = ::User.admin
swars_user = Swars::User.create!
key = Swars::BattleKeyGenerator.new.generate
Swars::Battle[key]&.destroy!
battle = Swars::Battle.create!(key: key) do |e|
  e.memberships.build(user: swars_user)
end
record = admin.swars_crawl_reservations.create!(attachment_mode: "with_zip", target_user_key: swars_user.key)
record.crawl!
record.reload
record.processed_at    # => Sat, 01 Mar 2025 18:28:31.000000000 JST +09:00
record.to_zip.size     # => 1378
# >> 2025-03-01T09:28:31.144Z pid=32701 tid=kt5 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=normal&page=1&user_id=user1040574
# >> user1040574 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=normal&page=1&user_id=user1040574
# >> user1040574 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=normal&page=1&user_id=user1040574
# >> user1040574 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=friend&page=1&user_id=user1040574
# >> user1040574 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=friend&page=1&user_id=user1040574
# >> user1040574 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=friend&page=1&user_id=user1040574
# >> user1040574 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=coach&page=1&user_id=user1040574
# >> user1040574 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&opponent_type=closed_event&page=1&user_id=user1040574
# >> user1040574 Page1 10分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&opponent_type=closed_event&page=1&user_id=user1040574
# >> user1040574 Page1 3分 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&opponent_type=closed_event&page=1&user_id=user1040574
# >> user1040574 Page1 10秒 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?init_pos_type=sprint&page=1&user_id=user1040574
# >> user1040574 Page1 ルール未指定 [全3件][新0件][最後]
# >>   BREAK (最後のページと思われるので終わる)
