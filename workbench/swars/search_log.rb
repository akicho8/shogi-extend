require "./setup"
# sql
# Swars::SearchLog.old_only(50.days).cleaner.call
# Swars::SearchLog.momentum_user_ids(period: 1000.days, at_least: 5) # => [966838, 257, 943988, 169, 135378, 181315, 746616, 129474, 890422]

sql
Swars::SearchLog.select(:user_id).distinct.count # => 114
Swars::SearchLog.distinct.count(:user_id)        # => 114



# Swars::User.find(257)           # => #<Swars::User id: 257, user_key: "ebitaro2", grade_id: 9, last_reception_at: nil, search_logs_count: 0, created_at: "2018-08-02 14:24:23.000000000 +0900", updated_at: "2023-11-29 02:44:41.000000000 +0900", ban_at: nil, latest_battled_at: "2018-08-02 14:24:23.000000000 +0900">
# .cleaner.call
# >>   Swars::SearchLog Count (0.9ms)  SELECT COUNT(DISTINCT `swars_search_logs`.`user_id`) FROM `swars_search_logs` /*application='ShogiWeb'*/
# >>   Swars::SearchLog Count (0.6ms)  SELECT COUNT(DISTINCT `swars_search_logs`.`user_id`) FROM `swars_search_logs` /*application='ShogiWeb'*/
