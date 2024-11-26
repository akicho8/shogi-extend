#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)
ForeignKey.disabled
Swars::Battle.destroy_all
Swars::User.destroy_all
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: true,  hard_crawl: true, page_max: 2).run
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: false, hard_crawl: true, page_max: 2).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", remote_run: true).run
# Swars::Importer::AllRuleImporter.new(user_key: "kinakom0chi", remote_run: true).run
# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: true, hard_crawl: true).run

# Swars::Importer::AllRuleImporter.new(user_key: "alice", last_page_break: false, hard_crawl: true, page_max: 3).run
# Swars::Battle.count             # => 3

Swars::Importer::AllRuleImporter.new(user_key: "muaqua2023", last_page_break: false, hard_crawl: true, page_max: 1, remote_run: true).run
Swars::Battle.count             # => 0

# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=muaqua2023
# >> muaqua2023 P1 10分 [全0件][新0件][最後]
# >> 新しい対局が見つからなかったので終わる(次のページはないと考える)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=sb&page=1&user_id=muaqua2023
# >> muaqua2023 P1 3分 [全0件][新0件][最後]
# >> 新しい対局が見つからなかったので終わる(次のページはないと考える)
# >> [fetch][history] https://shogiwars.heroz.jp/games/history?gtype=s1&page=1&user_id=muaqua2023
# >> muaqua2023 P1 10秒 [全0件][新0件][最後]
# >> 新しい対局が見つからなかったので終わる(次のページはないと考える)
