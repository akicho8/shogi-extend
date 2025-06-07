require "./setup"
# user1 = Swars::User.create!
# user2 = Swars::User.create!
# battles = []
# # battles << Swars::Battle.create_with_members!([user1, user2], {kifu_body_for_test: "▲68銀"})
# battles << Swars::Battle.create_with_members!([user1, user2], {kifu_body_for_test: "▲68銀△42銀"})
# battles << Swars::Battle.create_with_members!([user1, user2], {kifu_body_for_test: "▲68銀△42銀"})
# tp battles.collect(&:info)
# scope = Swars::Membership.where(id: battles.flat_map(&:membership_ids))
# object = QuickScript::Swars::TacticStatScript.new({period_key: :infinite}, {batch_size: 1, scope: scope})
# object.cache_write
# tp object.aggregate[:day7]      # => [{勝ち: 2, 勝率: 0.5, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 2, 人気度: 1.0, 登場率: 1.0, スタイル: "王道", 使用人数: 2, 登場回数: 4}]
# tp object.as_general_json

def case1(kifu_body_list)
  user1 = Swars::User.create!
  user2 = Swars::User.create!
  battles = kifu_body_list.collect { |e| Swars::Battle.create_with_members!([user1, user2], {kifu_body_for_test: e}) }
  scope = Swars::Membership.where(id: battles.flat_map(&:membership_ids))
  object = QuickScript::Swars::TacticStatScript.new({period_key: :infinite}, {batch_size: 1, scope: scope})
  object.cache_write
  object.aggregate[:day7]
end

case1(["▲68銀"])           # => [{勝ち: 1, 勝率: 1.0, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 0, 人気度: 1.0, 登場率: 0.5, スタイル: "王道", 使用人数: 1, 登場回数: 1}]
case1(["▲68銀△42銀"])     # => [{勝ち: 1, 勝率: 0.5, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 1, 人気度: 1.0, 登場率: 1.0, スタイル: "王道", 使用人数: 2, 登場回数: 2}]
case1(["▲68銀△42銀"] * 2) # => [{勝ち: 2, 勝率: 0.5, 名前: "嬉野流", 引分: 0, 種類: "戦法", 負け: 2, 人気度: 1.0, 登場率: 1.0, スタイル: "王道", 使用人数: 2, 登場回数: 4}]
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 1週間
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 1週間
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript それ以上
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript それ以上
# >> 2025-06-07T11:05:18.463Z pid=56544 tid=1634 INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 1週間
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 1週間
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:18 1/2  50.00 % T1 TacticStatScript それ以上
# >> 2025-06-07 20:05:18 2/2 100.00 % T0 TacticStatScript それ以上
# >> 2025-06-07 20:05:19 1/4  25.00 % T1 TacticStatScript 1週間
# >> 2025-06-07 20:05:19 2/4  50.00 % T0 TacticStatScript 1週間
# >> 2025-06-07 20:05:19 3/4  75.00 % T0 TacticStatScript 1週間
# >> 2025-06-07 20:05:19 4/4 100.00 % T0 TacticStatScript 1週間
# >> 2025-06-07 20:05:19 1/4  25.00 % T1 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:19 2/4  50.00 % T0 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:19 3/4  75.00 % T0 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:19 4/4 100.00 % T0 TacticStatScript 1ヶ月
# >> 2025-06-07 20:05:19 1/4  25.00 % T1 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:19 2/4  50.00 % T0 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:19 3/4  75.00 % T0 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:19 4/4 100.00 % T0 TacticStatScript 2ヶ月
# >> 2025-06-07 20:05:19 1/4  25.00 % T1 TacticStatScript それ以上
# >> 2025-06-07 20:05:19 2/4  50.00 % T0 TacticStatScript それ以上
# >> 2025-06-07 20:05:19 3/4  75.00 % T0 TacticStatScript それ以上
# >> 2025-06-07 20:05:19 4/4 100.00 % T0 TacticStatScript それ以上
