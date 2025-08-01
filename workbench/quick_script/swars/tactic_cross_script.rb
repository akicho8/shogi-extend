require "./setup"

def case1(grade_keys, kifu_body_list)
  users = grade_keys.collect { |e| Swars::User.create!(grade_key: e) }
  battles = kifu_body_list.collect { |e| Swars::Battle.create_with_members!(users, { kifu_body_for_test: e }) }
  scope = Swars::Membership.where(id: battles.flat_map(&:membership_ids))
  object = QuickScript::Swars::TacticCrossScript.new({}, { batch_size: 1, scope: scope, verbose: false })
  tp object.aggregate_now
end

case1(["1級", "1級"], ["▲68銀"])           # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 0.5, 出現回数: 1, 勝ち: 1, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 1.0}]
case1(["1級", "1級"], ["▲68銀△42銀"])     # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.5, 出現率: 1.0, 出現回数: 2, 勝ち: 1, 負け: 1, 引分: 0, 使用人数: 2, 人気度: 1.0}]
case1(["1級", "1級"], ["▲68銀△42銀"] * 2) # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.5, 出現率: 1.0, 出現回数: 4, 勝ち: 2, 負け: 2, 引分: 0, 使用人数: 2, 人気度: 1.0}]
case1(["1級", "1級"], ["▲68銀△62玉"])     # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 0.5, 出現回数: 1, 勝ち: 1, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 0.5}, {棋力: :"1級", 名前: "新米長玉", 種類: "戦法", スタイル: "準変態", 勝率: 0.0, 出現率: 0.5, 出現回数: 1, 勝ち: 0, 負け: 1, 引分: 0, 使用人数: 1, 人気度: 0.5}]

case1(["1級", "2級"], ["▲68銀"])           # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 出現回数: 1, 勝ち: 1, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 1.0}]
case1(["1級", "2級"], ["▲68銀△42銀"])     # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 出現回数: 1, 勝ち: 1, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 1.0}, {棋力: :"2級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 1.0, 出現回数: 1, 勝ち: 0, 負け: 1, 引分: 0, 使用人数: 1, 人気度: 1.0}]
case1(["1級", "2級"], ["▲68銀△42銀"] * 2) # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 出現回数: 2, 勝ち: 2, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 1.0}, {棋力: :"2級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 0.0, 出現率: 1.0, 出現回数: 2, 勝ち: 0, 負け: 2, 引分: 0, 使用人数: 1, 人気度: 1.0}]
case1(["1級", "2級"], ["▲68銀△62玉"])     # => [{棋力: :"1級", 名前: "嬉野流", 種類: "戦法", スタイル: "王道", 勝率: 1.0, 出現率: 1.0, 出現回数: 1, 勝ち: 1, 負け: 0, 引分: 0, 使用人数: 1, 人気度: 1.0}, {棋力: :"2級", 名前: "新米長玉", 種類: "戦法", スタイル: "準変態", 勝率: 0.0, 出現率: 1.0, 出現回数: 1, 勝ち: 0, 負け: 1, 引分: 0, 使用人数: 1, 人気度: 1.0}]

# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  1.0 |    0.5 |        1 |    1 |    0 |    0 |        1 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  0.5 |    1.0 |        2 |    1 |    1 |    0 |        2 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  0.5 |    1.0 |        4 |    2 |    2 |    0 |        2 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前     | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流   | 戦法 | 王道     |  1.0 |    0.5 |        1 |    1 |    0 |    0 |        1 |    0.5 |
# >> | 1級  | 新米長玉 | 戦法 | 準変態   |  0.0 |    0.5 |        1 |    0 |    1 |    0 |        1 |    0.5 |
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  1.0 |    1.0 |        1 |    1 |    0 |    0 |        1 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  1.0 |    1.0 |        1 |    1 |    0 |    0 |        1 |    1.0 |
# >> | 2級  | 嬉野流 | 戦法 | 王道     |  0.0 |    1.0 |        1 |    0 |    1 |    0 |        1 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前   | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流 | 戦法 | 王道     |  1.0 |    1.0 |        2 |    2 |    0 |    0 |        1 |    1.0 |
# >> | 2級  | 嬉野流 | 戦法 | 王道     |  0.0 |    1.0 |        2 |    0 |    2 |    0 |        1 |    1.0 |
# >> |------+--------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 棋力 | 名前     | 種類 | スタイル | 勝率 | 出現率 | 出現回数 | 勝ち | 負け | 引分 | 使用人数 | 人気度 |
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
# >> | 1級  | 嬉野流   | 戦法 | 王道     |  1.0 |    1.0 |        1 |    1 |    0 |    0 |        1 |    1.0 |
# >> | 2級  | 新米長玉 | 戦法 | 準変態   |  0.0 |    1.0 |        1 |    0 |    1 |    0 |        1 |    1.0 |
# >> |------+----------+------+----------+------+--------+----------+------+------+------+----------+--------|
