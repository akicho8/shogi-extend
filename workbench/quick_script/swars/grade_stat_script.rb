require "./setup"
QuickScript::Swars::GradeStatScript.primary_aggregate_call

# Swars::Membership.in_batches do |e|
#   c = 0
#   e.tagged_with("居飛車").each do |e|
#     o = e.opponent
#     unless o.note_tag_list.include?("対居飛車")
#       o.note_tag_list = o.note_tag_list + ["対居飛車"]
#       Retryable.retryable { o.save!(validate: false) }
#       c += 1
#     end
#   end
#   p c
# end

# e.opponent                      # => #<Swars::Membership id: 9427078, battle_id: 4717115, user_id: 337766, grade_id: 40, position: 1, created_at: "2020-09-19 21:00:45.000000000 +0900", updated_at: "2024-07-20 10:15:55.000000000 +0900", grade_diff: -10, think_max: 37, op_user_id: 244233, think_last: 7, think_all_avg: 7, think_end_avg: 6, ai_drop_total: 0, judge_id: 1, location_id: 2, style_id: nil, ek_score_without_cond: nil, ek_score_with_cond: nil, ai_wave_count: 0, ai_two_freq: 0.217391, ai_noizy_two_max: 2, ai_gear_freq: nil, opponent_id: 9427077, defense_tag_list: nil, attack_tag_list: nil, technique_tag_list: nil, note_tag_list: nil>

# tp Swars::Battle.create!.memberships.first.info
# params = {tag: "居飛車", rule_key: "ten_min"}
# params = {rule_key: "ten_min"}
# params = {}
# instance = QuickScript::Swars::GradeStatScript.new(params, {_method: "post"})
# instance.call # =>
# tp instance.counts_hash
# tp instance.aggregate2[:status]
# tp instance.internal_rows

# QuickScript::Swars::GradeStatScript.aggregated_value # => nil
# QuickScript::Swars::GradeStatScript.counts_hash      # =>
