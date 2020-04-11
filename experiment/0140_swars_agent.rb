#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

tp Swars::Agent.new(run_remote: true).index_get(gtype: "",  user_key: "kinakom0chi", page_index: 0)
# >> |-----------------------------------------+------------------------------------------------------------------------------------------------|
# >> | key                                     | user_infos                                                                                     |
# >> |-----------------------------------------+------------------------------------------------------------------------------------------------|
# >> | kkkkkfff-kinakom0chi-20191229_211058    | [{:user_key=>"kkkkkfff", :grade_key=>"2級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]    |
# >> | kinakom0chi-yt0007-20191229_205213      | [{:user_key=>"kinakom0chi", :grade_key=>"2級"}, {:user_key=>"yt0007", :grade_key=>"1級"}]      |
# >> | kinakom0chi-moemori-20191229_190200     | [{:user_key=>"kinakom0chi", :grade_key=>"2級"}, {:user_key=>"moemori", :grade_key=>"2級"}]     |
# >> | kinakom0chi-mattan45-20191229_184915    | [{:user_key=>"kinakom0chi", :grade_key=>"2級"}, {:user_key=>"mattan45", :grade_key=>"9級"}]    |
# >> | aozoraty-kinakom0chi-20191229_182419    | [{:user_key=>"aozoraty", :grade_key=>"1級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]    |
# >> | terukong-kinakom0chi-20191228_230358    | [{:user_key=>"terukong", :grade_key=>"初段"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]   |
# >> | 54675467a-kinakom0chi-20191228_222901   | [{:user_key=>"54675467a", :grade_key=>"2級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]   |
# >> | sutru-kinakom0chi-20191228_220650       | [{:user_key=>"sutru", :grade_key=>"1級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]       |
# >> | Doootwe-kinakom0chi-20191227_222320     | [{:user_key=>"Doootwe", :grade_key=>"2級"}, {:user_key=>"kinakom0chi", :grade_key=>"2級"}]     |
# >> | kinakom0chi-Kleiber2113-20191227_210448 | [{:user_key=>"kinakom0chi", :grade_key=>"2級"}, {:user_key=>"Kleiber2113", :grade_key=>"2級"}] |
# >> |-----------------------------------------+------------------------------------------------------------------------------------------------|
