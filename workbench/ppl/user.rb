require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => true
exit

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "XA", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "BX", result_key: "維持" })
Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] # => 

Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3 })
Ppl::Updater.update_raw(6, { name: "alice", result_key: "次点", age: 2, win: 2 })
Ppl::Updater.update_raw(7, { name: "alice", result_key: "昇段", age: 3, win: 1 })
user = Ppl::User["alice"]
user.age_min                                # => 
user.age_max                                # => 
user.runner_up_count                        # => 
user.win_max                                # => 
user.promotion_membership.league_season.season_number # => 
user.promotion_season_number                   # => 
user.promotion_win                          # => 
user.memberships_first.league_season.season_number       # => 
user.memberships_last.league_season.season_number       # => 
user.season_number_min                         # => 
user.season_number_max                         # => 
tp Ppl::LeagueSeason
tp Ppl::User
tp Ppl::Membership
