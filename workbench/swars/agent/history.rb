require "./setup"
# Swars::Agent::History.new(user_key: "testarossa00").fetch # => [全3件][新0件][最後]
# Swars::Agent::History.new(user_key: "abacus10", remote_run: true, verbose: true).fetch # => [全10件][新10件][続く]

history = Swars::Agent::History.new(user_key: "shikacha", remote_run: true, verbose: true, rule_key: :custom, xmode_key: :friend) # => #<Swars::Agent::History:0x0000000130d57ec0 @params={user_key: "shikacha", remote_run: true, verbose: true, rule_key: :custom, xmode_key: :friend}>
history.history_url # => "https://shogiwars.heroz.jp/games/history?gtype=sf&opponent_type=friend&user_id=shikacha"
history_box = history.fetch
tp history_box.all_keys
# history_box = Swars::Agent::History.new(user_key: "yukky1119", remote_run: true, verbose: true).fetch # => [全0件][新0件][最後]
# tp history_box.all_keys
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sf&opponent_type=friend&user_id=shikacha
# >> |-------------------------------------|
# >> | Hululudayo-shikacha-20250702_200538 |
# >> |-------------------------------------|
