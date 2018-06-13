#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::BattleRecord.destroy_all
Swars::BattleRecord.import(:basic_import, user_key: "hanairobiyori")
sleep(1)
Swars::BattleRecord.import(:old_record_destroy, time: 0.seconds.ago)

GeneralBattleRecord.import(:all_import, reset: true, sample: 1)
sleep(2)
GeneralBattleRecord.import(:old_record_destroy, time: 0.seconds.ago)
# >> ["2018-02-28 18:50:56", :basic_import, "begin", [11, 0]]
# >> ["2018-02-28 18:51:00", :basic_import, "end__", [11, 10], [0, 10]]
# >> ["2018-02-28 18:51:00", :old_record_destroy, "begin", [11, 10]]
# >> ["2018-02-28 18:51:01", :old_record_destroy, "end__", [11, 0], [0, -10]]
# >> ["2018-02-28 18:51:01", "begin", 2, 0]
# >> C
# >> ["2018-02-28 18:51:01", "end__", 4, 1]
# >> ["2018-02-28 18:51:03", "begin", 4, 1]
# >> 
# >> ["2018-02-28 18:51:03", "end__", 4, 0]
