require "./setup"
Swars::Agent::History.new(user_key: "testarossa00").fetch # => [全3件][新3件][最後]
Swars::Agent::History.new(user_key: "abacus10", remote_run: true, verbose: true).fetch # => [全10件][新9件][続く]
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=abacus10
