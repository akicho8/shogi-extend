require "./setup"
user_key = SecureRandom.hex
alice = Swars::User.create!(key: user_key)
2.times do
  Swars::Battle.create! do |e|
    e.memberships.build(user: alice)
  end
end
instance = QuickScript::Swars::UserGroupScript.new({ user_items_text: "(xname) #{user_key}" }, { _method: "post" })
instance.current_user_keys   # => ["56b643cf15649dbcc167ea427c0cda9a"]
instance.db_exist_user_keys  # => ["56b643cf15649dbcc167ea427c0cda9a"]
tp instance.rows.first

# sql
# user_key = SecureRandom.hex
# alice = Swars::User.create!(key: user_key)
# Swars::Battle.create! do |e|
#   e.memberships.build(user: alice)
# end
# QuickScript::Swars::UserGroupScript.new(user_items_text: user_key).call[:_v_bind][:value][:rows].size # => 1
#
# GoogleApi::ExpirationTracker.destroy_all
# QuickScript::Swars::UserGroupScript.new(user_items_text: user_key, google_sheet: true).call
# GoogleApi::ExpirationTracker.count          # => 1
# GoogleApi::ExpirationTracker.destroy_all

# >> |-----------------+------------------------------------------------------------------------------------------------------------------------------------------|
# >> |            名前 | (xname)                                                                                                                                  |
# >> |      ウォーズID | {_nuxt_link: {name: "56b643cf15649dbcc167ea427c0cda9a", to: {name: "swars-search", query: {query: "56b643cf15649dbcc167ea427c0cda9a"}}}} |
# >> |            最高 | 30級                                                                                                                                     |
# >> |            10分 | 30級                                                                                                                                     |
# >> |             3分 |                                                                                                                                          |
# >> |            10秒 |                                                                                                                                          |
# >> |      スプリント |                                                                                                                                          |
# >> |            勝率 | 100 %                                                                                                                                    |
# >> |            勢い | 13 %                                                                                                                                     |
# >> |            規範 | 60 点                                                                                                                                    |
# >> |          居飛車 | 0 %                                                                                                                                      |
# >> |        振り飛車 | 0 %                                                                                                                                      |
# >> |          主戦法 | 新嬉野流                                                                                                                                 |
# >> |          主囲い |                                                                                                                                          |
# >> |        直近対局 | 2025-04-30                                                                                                                               |
# >> |         リンク1 | {_nuxt_link: {name: "棋譜(2)", to: {name: "swars-search", query: {query: "56b643cf15649dbcc167ea427c0cda9a"}}}}                          |
# >> |         リンク2 | {_nuxt_link: {name: "プレイヤー情報", to: {name: "swars-users-key", params: {key: "56b643cf15649dbcc167ea427c0cda9a"}}}}                 |
# >> |         リンク3 | <a href="https://shogiwars.heroz.jp/users/mypage/56b643cf15649dbcc167ea427c0cda9a" target="_blank">本家</a>                              |
# >> |         リンク4 | <a href="https://www.google.co.jp/search?q=56b643cf15649dbcc167ea427c0cda9a+%E5%B0%86%E6%A3%8B" target="_blank">ググる</a>               |
# >> | 最高段位(index) | 39                                                                                                                                       |
# >> |-----------------+------------------------------------------------------------------------------------------------------------------------------------------|
