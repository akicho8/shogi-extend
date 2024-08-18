require "./setup"
tp Swars::Battle.create!.memberships.first.info
params = {tag: "居飛車", rule_key: "ten_min"}
params = {rule_key: "ten_min"}
params = {}
instance = QuickScript::Swars::GradeHistogramScript.new(params, {_method: "post"})
instance.call # => 
tp instance.counts_hash
tp instance.aggregate2[:status]
tp instance.internal_rows
