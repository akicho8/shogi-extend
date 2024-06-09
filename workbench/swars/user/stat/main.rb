require "./setup"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1787.18 ms"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1585.18 ms"

_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "412.84 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "193.28 ms"
1585.18 / 244.29                                                # => 6.488927094846289

Swars::User::Stat::ScopeExt::DELEGATE_METHODS # => [:filtered_battle_ids, :scope_ids, :ids_scope, :ids_count, :ordered_ids_scope, :sample_max, :win_only, :win_count, :lose_only, :lose_count, :draw_only, :draw_count, :win_ratio]
# s { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash }
