require "./setup"
# p _ { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(batch_size: 500000).call }

# p QuickScript::Swars::GradeStatScript::PrimaryAggregator.new.population_count
p QuickScript::Swars::GradeStatScript::PrimaryAggregator.new.call

# scope = Swars::Membership.where(id: Swars::Membership.last(200).collect(&:id))
# _ { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(scope: scope).call } # => "32.49 ms"
# s { QuickScript::Swars::GradeStatScript::PrimaryAggregator.new(scope: scope).call } # => {:memberships_count=>2, :counts_hash=>{"三段"=>{"__tag_nothing__"=>1, "高美濃囲い"=>1, "振り飛車"=>1, "大駒コンプリート"=>1, "対居飛車"=>1, "対抗形"=>1, "持久戦"=>1, "長手数"=>1, "割り打ちの銀"=>1}, "四段"=>{"__tag_nothing__"=>1, "対振り持久戦"=>1, "舟囲い"=>1, "居飛車"=>1, "対振り飛車"=>1, "大駒全ブッチ"=>1, "対抗形"=>1, "持久戦"=>1, "長手数"=>1}}, :primary_aggregated_at=>Sun, 25 Aug 2024 10:48:23.623478000 JST +09:00, :primary_aggregation_second=>0.006454}
