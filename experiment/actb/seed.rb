require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

Actb::Lineage.all.collect(&:key)                 # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
Actb::Judge.all.collect(&:key)                   # => ["win", "lose", "draw", "pending"]
Actb::Rule.all.collect(&:key)                    # => ["marathon_rule", "singleton_rule", "hybrid_rule"]
Actb::Final.all.collect(&:key)                   # => ["f_give_up", "f_disconnect", "f_success", "f_pending"]

10.times do
  Actb::Season.create!
end
Actb::Season.count              # => 11

# tp Actb.info

user1 = Colosseum::User.sysop
user2 = Colosseum::User.find_or_create_by!(key: "alice")

Colosseum::User.setup
# 8.times do |e|
#   Colosseum::User.create!
# end

# 問題作成
3.times do |i|
  question = user1.actb_questions.create! do |e|
    e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l#{i+1}p 1"
    e.moves_answers.build(moves_str: "G*4b")
    e.moves_answers.build(moves_str: "G*5b")
    e.moves_answers.build(moves_str: "G*6b")

    e.updated_at = Time.current - 1.days + i.hours

    e.time_limit_sec        = 60 * 3
    e.difficulty_level      = 5
    e.title                 = "(title)"
    e.description           = "(description)"
    e.hint_description      = "(hint_description)"
    e.source_desc           = "(source_desc)"
    e.other_twitter_account = "(other_twitter_account)"
  end
end
Actb::Question.count           # => 3

question = Actb::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 171, user_id: 57, type: "Actb::TrashBox", created_at: "2020-05-31 14:10:34", updated_at: "2020-05-31 14:10:34">

# 2番目の問題は下書きへ
question = Actb::Question.second!
question.folder_key           # => "active"
question.folder_key = :draft
question.save!                 # => true
question.folder.type           # => "Actb::DraftBox"
# tp question.as_json
# exit

# 部屋を立てる
room = Actb::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end

room.users.collect(&:name)                      # => ["運営", "名無しの棋士2号"]

# 対戦を作成
battle = room.battles.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
battle                          # => #<Actb::Battle id: 1535, room_id: 1041, parent_id: nil, rule_id: 1, final_id: 4, begin_at: "2020-05-31 14:10:37", end_at: nil, rensen_index: 0, created_at: "2020-05-31 14:10:37", updated_at: "2020-05-31 14:10:37">

battle.users.count                # => 2
battle.rensen_index               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 1536, room_id: 1041, parent_id: 1535, rule_id: 1, final_id: 4, begin_at: "2020-05-31 14:10:37", end_at: nil, rensen_index: 1, created_at: "2020-05-31 14:10:37", updated_at: "2020-05-31 14:10:37">
battle2.rensen_index                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>9, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_description"=>"(hint_description)", "source_desc"=>"(source_desc)", "other_twitter_account"=>"(other_twitter_account)", "user"=>{"id"=>57, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ox_mark_key = Actb::OxMarkInfo[i.modulo(Actb::OxMarkInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(ox_mark_key))
end

# 終局
battle.katimashita(user1, :win, :f_success)

# 切断したことにする
user1.actb_current_xrecord.update!(final: Actb::Final.fetch(:f_disconnect))
tp user1.actb_current_xrecord
tp user1.actb_master_xrecord

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# 問題に対してコメント
5.times do
  question = Actb::Question.first!
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 11, user_id: 57, question_id: 7, body: "message", created_at: "2020-05-31 14:10:38", updated_at: "2020-05-31 14:10:38">, #<Actb::QuestionMessage id: 12, user_id: 57, question_id: 7, body: "message", created_at: "2020-05-31 14:10:38", updated_at: "2020-05-31 14:10:38">, #<Actb::QuestionMessage id: 13, user_id: 57, question_id: 7, body: "message", created_at: "2020-05-31 14:10:38", updated_at: "2020-05-31 14:10:38">, #<Actb::QuestionMessage id: 14, user_id: 57, question_id: 7, body: "message", created_at: "2020-05-31 14:10:38", updated_at: "2020-05-31 14:10:38">, #<Actb::QuestionMessage id: 15, user_id: 57, question_id: 7, body: "message", created_at: "2020-05-31 14:10:38", updated_at: "2020-05-31 14:10:38">
  question.messages_count                    # => 1, 2, 3, 4, 5
end

tp Actb::Question

tp Actb.info
# >> |------------------+---------------------------|
# >> |               id | 71                        |
# >> |          user_id | 57                        |
# >> |        season_id | 62                        |
# >> |         judge_id | 69                        |
# >> |         final_id | 2                         |
# >> |     battle_count | 1                         |
# >> |        win_count | 1                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 1.0                       |
# >> |           rating | 1516                      |
# >> | rating_last_diff | 16                        |
# >> |       rating_max | 1516                      |
# >> |     rensho_count | 1                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 1                         |
# >> |       renpai_max | 0                         |
# >> |     create_count | 1                         |
# >> |       generation | 11                        |
# >> |       created_at | 2020-05-31 23:10:34 +0900 |
# >> |       updated_at | 2020-05-31 23:10:38 +0900 |
# >> | disconnect_count | 1                         |
# >> |  disconnected_at | 2020-05-31 23:10:38 +0900 |
# >> |------------------+---------------------------|
# >> |------------------+---------------------------|
# >> |               id | 57                        |
# >> |          user_id | 57                        |
# >> |         judge_id | 72                        |
# >> |         final_id | 4                         |
# >> |     battle_count | 0                         |
# >> |        win_count | 0                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 0.0                       |
# >> |           rating | 1500                      |
# >> | rating_last_diff | 0                         |
# >> |       rating_max | 1500                      |
# >> |     rensho_count | 0                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 0                         |
# >> |       renpai_max | 0                         |
# >> |       created_at | 2020-05-31 23:10:34 +0900 |
# >> |       updated_at | 2020-05-31 23:10:34 +0900 |
# >> | disconnect_count | 0                         |
# >> |  disconnected_at |                           |
# >> |------------------+---------------------------|
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> | id | user_id | folder_id | lineage_id | init_sfen                                 | time_limit_sec | difficulty_level | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clip_marks_count | messages_count |
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> |  7 |      57 |       171 |        120 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-31 23:10:37 +0900 | 2020-05-31 23:10:37 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                1 |                0 |              5 |
# >> |  8 |      57 |       170 |        120 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-31 23:10:37 +0900 | 2020-05-31 23:10:37 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               1 |                0 |                0 |              0 |
# >> |  9 |      57 |       169 |        120 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-31 23:10:37 +0900 | 2020-05-31 01:10:37 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |                1 |              0 |
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | Colosseum::User        |    14 |     70 |
# >> | Actb::Question         |     3 |      9 |
# >> | Actb::QuestionMessage  |     5 |     15 |
# >> | Actb::Room             |     1 |   1041 |
# >> | Actb::RoomMembership   |     2 |   2082 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |   1536 |
# >> | Actb::BattleMembership |     4 |   3072 |
# >> | Actb::Season           |    11 |     62 |
# >> | Actb::SeasonXrecord    |    14 |     84 |
# >> | Actb::Setting          |    14 |     70 |
# >> | Actb::GoodMark         |     1 |      3 |
# >> | Actb::BadMark          |     1 |      3 |
# >> | Actb::ClipMark         |     1 |      3 |
# >> | Actb::Folder           |    42 |    210 |
# >> | Actb::Lineage          |     7 |    126 |
# >> | Actb::Judge            |     4 |     72 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
