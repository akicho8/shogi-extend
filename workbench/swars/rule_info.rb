require "./setup"
Swars::RuleInfo[nil]            # => nil
Swars::RuleInfo[""]             # => #<Swars::RuleInfo:0x000000010a256830 @attributes={:key=>:ten_min, :name=>"10分", :long_name=>"10分切れ負け", :swars_magic_key=>"", :csa_time_limit=>"00:10+00", :life_time=>10 minutes, :real_life_time=>nil, :ittezume_jirasi_sec=>1.0 minute, :kangaesugi_sec=>2.5 minutes, :kangaesugi_like_houti_sec=>3 minutes, :toryo_houti_sec=>1 minute, :taisekimati_sec=>5 minutes, :related_time_p=>true, :resignation_limit=>3 minutes, :most_min_turn_max_limit=>35, :code=>0}>
