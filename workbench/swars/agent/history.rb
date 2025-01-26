require "./setup"
Swars::Agent::History.new(user_key: "testarossa00").fetch # => [全3件][新0件][最後]
Swars::Agent::History.new(user_key: "abacus10", remote_run: true, verbose: true).fetch # => [全10件][新10件][続く]
history_result = Swars::Agent::History.new(user_key: "kinakom0chi", remote_run: true, verbose: true).fetch # => [全10件][新8件][続く]
tp history_result.all_keys
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=abacus10
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=kinakom0chi
# >> |---------------------------------------------|
# >> | kinakom0chi-raoZou-20250126_185805          |
# >> | Hyder-kinakom0chi-20250125_224224           |
# >> | CrazyNasubi-kinakom0chi-20250125_185321     |
# >> | kinakom0chi-Kaisei99-20250125_180059        |
# >> | kinakom0chi-SatohKazuyosi-20250125_172600   |
# >> | UMR2024-kinakom0chi-20250124_225719         |
# >> | hide19930-kinakom0chi-20250120_230604       |
# >> | kinakom0chi-batch0622-20250120_224255       |
# >> | igisudofu-kinakom0chi-20250119_211339       |
# >> | kinakom0chi-takemikazuchi42-20250119_194837 |
# >> |---------------------------------------------|
