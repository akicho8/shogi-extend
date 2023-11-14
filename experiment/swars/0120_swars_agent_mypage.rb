#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

regexp = /(#{Swars::RuleInfo.collect(&:name).join("|")})\s*(\S+[級段])/o

doc = Swars::Agent::Mypage.new(remote_run: false, user_key: "testarossa00").doc
doc.search("#user_dankyu tr").text.scan(regexp) # => [["10分", "10000級"], ["3分", "10000級"], ["10秒", "10000級"]]

# doc = Swars::Agent::Mypage.new(remote_run: true, user_key: "BOUYATETSU5").doc
# list = doc.search("#user_dankyu tr").text.scan(regexp).collect do |rule, grade|
#   { rule: Swars::RuleInfo.fetch(rule), grade: Swars::GradeInfo.fetch(grade), }
# end
# list                            # => [{:rule=>#<Swars::RuleInfo:0x000000010a879a28 @attributes={:key=>:ten_min, :name=>"10分", :long_name=>"10分切れ負け", :swars_magic_key=>"", :csa_time_limit=>"00:10+00", :life_time=>10 minutes, :real_life_time=>nil, :teasing_limit=>1.0 minute, :short_leave_alone=>2.5 minutes, :long_leave_alone=>3 minutes, :long_leave_alone2=>5 minutes, :related_time_p=>true, :resignation_limit=>3 minutes, :most_min_turn_max_limit=>35, :code=>0}>, :grade=>#<Swars::GradeInfo:0x000000010a976a98 @attributes={:key=>:六段, :visualize=>true, :select_option=>true, :code=>4}>}, {:rule=>#<Swars::RuleInfo:0x000000010a879960 @attributes={:key=>:three_min, :name=>"3分", :long_name=>"3分切れ負け", :swars_magic_key=>"sb", :csa_time_limit=>"00:03+00", :life_time=>3 minutes, :real_life_time=>nil, :teasing_limit=>45 seconds, :short_leave_alone=>30 seconds, :long_leave_alone=>1 minute, :long_leave_alone2=>2 minutes, :related_time_p=>true, :resignation_limit=>1 minute, :most_min_turn_max_limit=>35, :code=>1}>, :grade=>#<Swars::GradeInfo:0x000000010a9769d0 @attributes={:key=>:五段, :visualize=>true, :select_option=>true, :code=>5}>}, {:rule=>#<Swars::RuleInfo:0x000000010a8798e8 @attributes={:key=>:ten_sec, :name=>"10秒", :long_name=>"1手10秒", :swars_magic_key=>"s1", :csa_time_limit=>"00:00+10", :life_time=>1 hour, :real_life_time=>0, :teasing_limit=>nil, :short_leave_alone=>nil, :long_leave_alone=>nil, :long_leave_alone2=>nil, :related_time_p=>false, :resignation_limit=>1 minute, :most_min_turn_max_limit=>35, :code=>2}>, :grade=>#<Swars::GradeInfo:0x000000010a976a98 @attributes={:key=>:六段, :visualize=>true, :select_option=>true, :code=>4}>}]
# 
# rule_grade_list

# doc.search("#user_dankyu tr").each do |e|
#   if md = e.text.match(regexp)
#     p md
#   end
# end
