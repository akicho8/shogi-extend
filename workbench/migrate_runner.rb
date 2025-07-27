require "./setup"
<<<<<<< HEAD
battles_max = 50
Swars::User.in_batches do |scope|
  scope = scope.joins(:battles)
  scope = scope.group("swars_users.id")
  scope = scope.having("COUNT(swars_battles.id) > ?", battles_max)
  scope.each do |user|
    if Swars::User::Vip.auto_crawl_user_keys.include?(user.key)
      battles_max2 = 10
    else
      battles_max2 = 50
    end
    battles = user.battles
    # puts battles.collect(&:accessed_at)
    battles = battles.order(accessed_at: :desc).offset(battles_max2)
    # puts
    # puts battles.collect(&:accessed_at)
    p [user.key, battles.size]
    # battles.destroy_all
    exit
  end
end
=======

# battles_max = 50
# Swars::User.in_batches do |scope|
#   scope = scope.joins(:battles)
#   scope = scope.group("swars_users.id")
#   scope = scope.having("COUNT(swars_battles.id) > ?", battles_max)
#   scope.each do |user|
#     if Swars::User::Vip.auto_crawl_user_keys.include?(user.key)
#       battles_max2 = 10
#     else
#       battles_max2 = 50
#     end
#     battles = user.battles
#     # puts battles.collect(&:accessed_at)
#     battles = battles.order(accessed_at: :desc).offset(battles_max2)
#     # puts
#     # puts battles.collect(&:accessed_at)
#     p [user.key, battles.size]
#     # battles.destroy_all
#     exit
#   end
# end
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                 id | 617345                                                                                                                                                                                                                                                              |
# >> |                key | Kato_Hifumi-SiroChannel-20190317_140844                                                                                                                                                                                                                             |
# >> |         battled_at | 2019-03-17 14:08:44 +0900                                                                                                                                                                                                                                           |
# >> |            csa_seq | [["+7776FU", 563], ["-3334FU", 598], ["+2726FU", 561], ["-2233KA", 595], ["+2625FU", 553], ["-4344FU", 579], ["+3948GI", 551], ["-8242HI", 577], ["+5968OU", 548], ["-5162OU", 566], ["+6878OU", 546], ["-6272OU", 564], ["+5756FU", 543], ["-3132GI", 541], ["+... |
# >> |        win_user_id | 23501                                                                                                                                                                                                                                                               |
# >> |           turn_max | 57                                                                                                                                                                                                                                                                  |
# >> |          meta_info | {}                                                                                                                                                                                                                                                                  |
# >> |         created_at | 2020-02-18 09:43:04 +0900                                                                                                                                                                                                                                           |
# >> |         updated_at | 2024-11-06 19:48:09 +0900                                                                                                                                                                                                                                           |
# >> |         start_turn |                                                                                                                                                                                                                                                                     |
# >> |      critical_turn | 18                                                                                                                                                                                                                                                                  |
# >> |          sfen_body | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 moves 7g7f 3c3d 2g2f 2b3c 2f2e 4c4d 3i4h 8b4b 5i6h 5a6b 6h7h 6b7b 5g5f 3a3b 7i6h 3b4c 3g3f 4d4e 8h3c 2a3c 2e2d 2c2d 2h2d P*2b P*2c B*3a 2c2b+ 4b2b P*2c 2b2a B*2b 4c3b 2b1a+ 2a2b ... |
# >> |         image_turn |                                                                                                                                                                                                                                                                     |
# >> |      outbreak_turn | 32                                                                                                                                                                                                                                                                  |
# >> |        accessed_at | 2024-04-22 18:15:22 +0900                                                                                                                                                                                                                                           |
# >> |          sfen_hash | 0f8611aa1dc8957fc3aa0d4bc5a3900a                                                                                                                                                                                                                                    |
# >> |           xmode_id | 3                                                                                                                                                                                                                                                                   |
# >> |          preset_id | 1                                                                                                                                                                                                                                                                   |
# >> |            rule_id | 1                                                                                                                                                                                                                                                                   |
# >> |           final_id | 3                                                                                                                                                                                                                                                                   |
# >> |   analysis_version | 3                                                                                                                                                                                                                                                                   |
# >> |  starting_position |                                                                                                                                                                                                                                                                     |
# >> |           imode_id | 1                                                                                                                                                                                                                                                                   |
# >> |   defense_tag_list |                                                                                                                                                                                                                                                                     |
# >> |    attack_tag_list |                                                                                                                                                                                                                                                                     |
# >> | technique_tag_list |                                                                                                                                                                                                                                                                     |
# >> |      note_tag_list |                                                                                                                                                                                                                                                                     |
# >> |--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
>>>>>>> 8486d7473 ([feat] migrate_runner の調整)
