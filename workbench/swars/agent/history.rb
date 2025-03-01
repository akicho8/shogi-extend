require "./setup"
# Swars::Agent::History.new(user_key: "testarossa00").fetch # => [全3件][新0件][最後]
# Swars::Agent::History.new(user_key: "abacus10", remote_run: true, verbose: true).fetch # => [全10件][新10件][続く]
history_result = Swars::Agent::History.new(user_key: "kinakom0chi", remote_run: true, verbose: true).fetch # => [全10件][新10件][続く]
tp history_result.all_keys
# history_result = Swars::Agent::History.new(user_key: "yukky1119", remote_run: true, verbose: true).fetch # => [全0件][新0件][最後]
# tp history_result.all_keys
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?user_id=kinakom0chi
# >> |---------------------------------------------|
# >> | sumisuu1234-kinakom0chi-20250203_232745     |
# >> | kinakom0chi-Takumi1993-20250203_225511      |
# >> | ipponmauso-kinakom0chi-20250203_011530      |
# >> | minamo_scape-kinakom0chi-20250203_004844    |
# >> | reiaiuchi0-kinakom0chi-20250203_003318      |
# >> | momokamasayoshi-kinakom0chi-20250203_001121 |
# >> | kinakom0chi-shishikame-20250202_230235      |
# >> | gatabee-kinakom0chi-20250202_224039         |
# >> | highso-kinakom0chi-20250202_221451          |
# >> | taca110-kinakom0chi-20250202_215358         |
# >> |---------------------------------------------|
