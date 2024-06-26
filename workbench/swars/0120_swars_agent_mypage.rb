#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# mypage_result = Swars::Agent::Mypage.new(remote_run: false, user_key: "testarossa00").fetch
# tp mypage_result.list
#
mypage_result = Swars::Agent::Mypage.new(remote_run: true, user_key: "testarossa00").fetch
mypage_result                   # => #<Swars::Agent::MypageResult:0x0000000109d11488 @list=[{:rule=>#<Swars::RuleInfo:0x000000010993eb30 @attributes={:key=>:ten_min, :name=>"10分", :long_name=>"10分切れ負け", :swars_magic_key=>"", :csa_time_limit=>"00:10+00", :life_time=>10 minutes, :real_life_time=>nil, :ittezume_jirasi_sec=>1.0 minute, :kangaesugi_sec=>2.5 minutes, :toryo_houti_sec=>3 minutes, :taisekimati_sec=>5 minutes, :related_time_p=>true, :resignation_limit=>3 minutes, :most_min_turn_max_limit=>35, :code=>0}>, :grade=>#<Swars::GradeInfo:0x0000000109312b30 @attributes={:key=>:"10000級", :visualize=>false, :select_option=>false, :code=>40}>}, {:rule=>#<Swars::RuleInfo:0x000000010993e3b0 @attributes={:key=>:three_min, :name=>"3分", :long_name=>"3分切れ負け", :swars_magic_key=>"sb", :csa_time_limit=>"00:03+00", :life_time=>3 minutes, :real_life_time=>nil, :ittezume_jirasi_sec=>45 seconds, :kangaesugi_sec=>30 seconds, :toryo_houti_sec=>1 minute, :taisekimati_sec=>2 minutes, :related_time_p=>true, :resignation_limit=>1 minute, :most_min_turn_max_limit=>35, :code=>1}>, :grade=>#<Swars::GradeInfo:0x0000000109312b30 @attributes={:key=>:"10000級", :visualize=>false, :select_option=>false, :code=>40}>}, {:rule=>#<Swars::RuleInfo:0x000000010993e338 @attributes={:key=>:ten_sec, :name=>"10秒", :long_name=>"1手10秒", :swars_magic_key=>"s1", :csa_time_limit=>"00:00+10", :life_time=>1 hour, :real_life_time=>0, :ittezume_jirasi_sec=>nil, :kangaesugi_sec=>nil, :toryo_houti_sec=>nil, :taisekimati_sec=>nil, :related_time_p=>false, :resignation_limit=>1 minute, :most_min_turn_max_limit=>35, :code=>2}>, :grade=>#<Swars::GradeInfo:0x0000000109312b30 @attributes={:key=>:"10000級", :visualize=>false, :select_option=>false, :code=>40}>}]>
tp mypage_result.list

# tp Swars::User.all

# >> |------+---------|
# >> | rule | grade   |
# >> |------+---------|
# >> | 10分 | 10000級 |
# >> | 3分  | 10000級 |
# >> | 10秒 | 10000級 |
# >> |------+---------|
