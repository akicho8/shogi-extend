#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

Swars::Battle.destroy_all
Swars::Importer::AllRuleImporter.new(user_key: "DevUser1").run
Swars::Battle.count             # => 3
Swars::Battle.cleanup(expires_in: 0.seconds)
Swars::Battle.count             # => 1
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=DevUser1
# >> DevUser1 P1 10分 [全3件][新3件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser1-YamadaTaro-20200101_123401?locale=ja
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser2-YamadaTaro-20200101_123402?locale=ja
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser3-YamadaTaro-20200101_123403?locale=ja
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=DevUser1
# >> DevUser1 P1 3分 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=DevUser1
# >> DevUser1 P1 10秒 [全3件][新0件][最後]
# >> 最後のページと思われるので終わる
