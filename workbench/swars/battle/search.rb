require "./setup"

user = Swars::User["kinakom0chi"]
user.battles.find_all_by_query("", target_owner: user).count                              # => 297
user.battles.find_all_by_query("id:46808270,48210290").count                              # => 0
user.battles.find_all_by_query("勝敗:勝ち", target_owner: user).count                     # => 151
user.battles.find_all_by_query("日付:2020-03", target_owner: user).count                  # => 1
user.battles.find_all_by_query("tag:ボナンザ囲い tag:腰掛け銀", target_owner: user).count # => 0
user.battles.find_all_by_query("-tag:力戦", target_owner: user).count                     # => 293
user.battles.find_all_by_query("力差:>=1 力差:<=1", target_owner: user).count             # => 67
user.battles.find_all_by_query("垢BAN:絞る", target_owner: user).count                    # => 0
user.battles.find_all_by_query("垢BAN:除外", target_owner: user).count                    # => 297

user = Swars::User["slowstep3210"]
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true).ids } # => "82.64 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).ids } # => "15.33 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: false).to_a } # => "15.71 ms"
_ { user.reload.battles.find_all_by_query("勝敗:勝ち", target_owner: user, with_includes: true).to_a } # => "339.63 ms"
