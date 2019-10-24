#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

Swars::Battle.destroy_all
Swars::Battle.import(:user_import, user_key: "devuser1")
sleep(1)
Swars::Battle.import(:old_record_destroy, time: 0.seconds.ago)

# >> ["2018-02-28 18:50:56", :user_import, "begin", [11, 0]]
# >> ["2018-02-28 18:51:00", :user_import, "end__", [11, 10], [0, 10]]
# >> ["2018-02-28 18:51:00", :old_record_destroy, "begin", [11, 10]]
# >> ["2018-02-28 18:51:01", :old_record_destroy, "end__", [11, 0], [0, -10]]
# >> ["2018-02-28 18:51:01", "begin", 2, 0]
# >> C
# >> ["2018-02-28 18:51:01", "end__", 4, 1]
# >> ["2018-02-28 18:51:03", "begin", 4, 1]
# >> 
# >> ["2018-02-28 18:51:03", "end__", 4, 0]
