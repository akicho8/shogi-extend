require "./setup"

user = Swars::User["kinakom0chi"]
user.battles.find_all_by_query("勝敗:勝ち", target_owner: user).count                     # => 2
user.battles.find_all_by_query("日付:2020-03", target_owner: user).count                  # => 1
user.battles.find_all_by_query("tag:ボナンザ囲い tag:腰掛け銀", target_owner: user).count # => 1
user.battles.find_all_by_query("-tag:力戦", target_owner: user).count                     # => 1
user.battles.find_all_by_query("力差:>=1 力差:<=1", target_owner: user).count             # => 1

user = Swars::User["slowstep3210"]
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true ).ids } # => "191.46 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).ids } # => "17.83 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).to_a } # => "31.21 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true ).to_a } # => "283.12 ms"
