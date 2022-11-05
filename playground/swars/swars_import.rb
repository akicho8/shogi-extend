#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
DbCop.foreign_key_checks_disable
Swars::Battle.destroy_all
Swars::User.destroy_all
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", last_page_break: true,  early_break: true, page_max: 2).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", last_page_break: false, early_break: true, page_max: 2).run
Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", last_page_break: false, early_break: true, page_max: 1, remote_run: true).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", last_page_break: false, early_break: false, page_max: 2).run
Swars::Battle.count             # => 3
# >> [fetch][index] /games/history?gtype=&page=1&user_id=kinakom0chi
# >> [kinakom0chi][P1][10分][3件][最後]
# >> [fetch][show] /games/DevUser1-YamadaTaro-20200101_123401
# >> [fetch][show] /games/DevUser2-YamadaTaro-20200101_123402
# >> [fetch][show] /games/DevUser3-YamadaTaro-20200101_123403
# >> [fetch][index] /games/history?gtype=sb&page=1&user_id=kinakom0chi
# >> [kinakom0chi][P1][3分][3件][最後]
# >> [P1] 新しいレコードがなかった --> break
# >> [fetch][index] /games/history?gtype=s1&page=1&user_id=kinakom0chi
# >> [kinakom0chi][P1][10秒][3件][最後]
# >> [P1] 新しいレコードがなかった --> break
