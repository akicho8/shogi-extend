require "./setup"

user = Swars::User["kinakom0chi"]
user.battles.find_all_by_query("id:46808270,48210290").count                              # => 2
user.battles.find_all_by_query("勝敗:勝ち", target_owner: user).count                     # => 2
user.battles.find_all_by_query("日付:2020-03", target_owner: user).count                  # => 1
user.battles.find_all_by_query("tag:ボナンザ囲い tag:腰掛け銀", target_owner: user).count # => 1
user.battles.find_all_by_query("-tag:力戦", target_owner: user).count                     # => 1
user.battles.find_all_by_query("力差:>=1 力差:<=1", target_owner: user).count             # => 1

user = Swars::User["slowstep3210"]
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true ).ids } # => "73.82 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).ids } # => "6.62 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).to_a } # => "26.39 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true ).to_a } # => "176.90 ms"
