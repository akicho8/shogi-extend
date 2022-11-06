#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled
Swars::Battle.destroy_all
Swars::User.destroy_all
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: true,  early_break: true, page_max: 2).run
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: false, early_break: true, page_max: 2).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", remote_run: true).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", remote_run: true).run
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: true, early_break: true).run
Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: false, early_break: true, page_max: 3).run
Swars::Battle.count             # => 3
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=alice
# >> [alice][P1][10分][全3件][新3件][最後]
# >> [P1] 最後のページと思われるので終わる
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser1-YamadaTaro-20200101_123401?locale=ja
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser2-YamadaTaro-20200101_123402?locale=ja
# >> [fetch][record] https://shogiwars.heroz.jp/games/DevUser3-YamadaTaro-20200101_123403?locale=ja
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=alice
# >> [alice][P1][3分][全3件][新0件][最後]
# >> [P1] 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=alice
# >> [alice][P1][10秒][全3件][新0件][最後]
# >> [P1] 最後のページと思われるので終わる
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=alice
# >> [alice][P1][10分][全3件][新0件][最後]
# >> [P1] 新しい対局が見つからなかったので終わる(次のページはないと考える)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=alice
# >> [alice][P1][3分][全3件][新0件][最後]
# >> [P1] 新しい対局が見つからなかったので終わる(次のページはないと考える)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=alice
# >> [alice][P1][10秒][全3件][新0件][最後]
# >> [P1] 新しい対局が見つからなかったので終わる(次のページはないと考える)
