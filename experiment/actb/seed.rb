require "./setup"

User.delete_all

Actb.destroy_all
Actb.setup

# Actb::Question.count            # => 1
# exit

Actb::Lineage.all.collect(&:key)                 # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]
Actb::Judge.all.collect(&:key)                   # => ["win", "lose", "draw", "pending"]
Actb::Rule.all.collect(&:key)                    # => ["marathon_rule", "singleton_rule", "hybrid_rule"]
Actb::Final.all.collect(&:key)                   # => ["f_give_up", "f_disconnect", "f_success", "f_draw", "f_pending"]

10.times do
  Actb::Season.create!
end
Actb::Season.count              # => 11

# tp Actb.info

user1 = User.sysop
user2 = User.find_or_create_by!(key: "alice")

User.setup
# 8.times do |e|
#   User.create!
# end

# 問題作成
10.times do |i|
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
    e.hint_desc             = "(hint_desc)"
    if i.odd?
      e.other_author        = "(other_author)"
    end
  end
end
Actb::Question.count           # => 23

question = Actb::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 54, user_id: 18, type: "Actb::TrashBox", created_at: "2020-06-24 11:25:29", updated_at: "2020-06-24 11:25:29">

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
battle                          # => #<Actb::Battle id: 10, room_id: 7, parent_id: nil, rule_id: 7, final_id: 5, begin_at: "2020-06-24 11:25:31", end_at: nil, battle_pos: 0, created_at: "2020-06-24 11:25:31", updated_at: "2020-06-24 11:25:31">

battle.users.count                # => 2
battle.battle_pos               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 11, room_id: 7, parent_id: 10, rule_id: 7, final_id: 5, begin_at: "2020-06-24 11:25:31", end_at: nil, battle_pos: 1, created_at: "2020-06-24 11:25:31", updated_at: "2020-06-24 11:25:31">
battle2.battle_pos                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>51, "init_sfen"=>"position sfen ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いの弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*7d 8b9b G*8b", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*7d 8b7a G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>52, "init_sfen"=>"position sfen 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"斜めに弱い", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*2c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>53, "init_sfen"=>"position sfen 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"桂馬をうまく使う", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*2c 1a2a G*3a", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*2c 2b2c G*1b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>54, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"棺桶美濃あるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>55, "init_sfen"=>"position sfen ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いあるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"B*7a 8b9b P*9c 8a9c G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>56, "init_sfen"=>"position sfen ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"成っちゃだめ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*9c 8a9c 8b8a", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>57, "init_sfen"=>"position sfen 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"銀の弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*2b 3a2b G*3b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>58, "init_sfen"=>"position sfen 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"玉をひっぱり上げる", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b2a G*2b", "end_sfen"=>nil}, {"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b1b G*2b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>59, "init_sfen"=>"position sfen 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"はじまりの桂", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*4c", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"N*6c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>60, "init_sfen"=>"position sfen ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"致命傷になる玉の早逃げ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>18, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0004_fallback_avatar_icon-acd5a7abb08f8e740c94bd9d44ddb048763b2eab5e74418b18b6a1672ce2f3c7.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*7d", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}]

# 最初の問題に2度解答する
# 2.times do
#   question = Actb::Question.first
#   user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(:correct))
# end

# # すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ox_mark_key = Actb::OxMarkInfo[i.modulo(Actb::OxMarkInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(ox_mark_key))
end

# tp Actb::Season.all
# tp user1.actb_season_xrecords
# 
# exit
puts user1.info
# exit

# 終局
battle.judge_final_set(user1, :win, :f_success)

# 切断したことにする
user1.actb_latest_xrecord.update!(final: Actb::Final.fetch(:f_disconnect))
tp user1.actb_latest_xrecord
tp user1.actb_main_xrecord

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# 問題に対してコメント
5.times do
  question = Actb::Question.first!
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 13, user_id: 18, question_id: 49, body: "message", created_at: "2020-06-24 11:25:32", updated_at: "2020-06-24 11:25:32">, #<Actb::QuestionMessage id: 14, user_id: 18, question_id: 49, body: "message", created_at: "2020-06-24 11:25:32", updated_at: "2020-06-24 11:25:32">, #<Actb::QuestionMessage id: 15, user_id: 18, question_id: 49, body: "message", created_at: "2020-06-24 11:25:32", updated_at: "2020-06-24 11:25:32">, #<Actb::QuestionMessage id: 16, user_id: 18, question_id: 49, body: "message", created_at: "2020-06-24 11:25:32", updated_at: "2020-06-24 11:25:32">, #<Actb::QuestionMessage id: 17, user_id: 18, question_id: 49, body: "message", created_at: "2020-06-24 11:25:32", updated_at: "2020-06-24 11:25:32">
  question.messages_count                    # => 1, 2, 3, 4, 5
end

tp Actb::Season
tp Actb::Question

tp Actb.info
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml (13)
# >> |--------------------+--------|
# >> |               名前 | 運営   |
# >> |       レーティング | 1500.0 |
# >> |             クラス | C-     |
# >> |         作成問題数 | 23     |
# >> | 最新シーズン情報ID | 28     |
# >> | 永続的プロフ情報ID | 18     |
# >> |         部屋入室数 | 1      |
# >> |             対局数 | 2      |
# >> |         問題履歴数 | 23     |
# >> |     バトル中発言数 | 0      |
# >> |       ロビー発言数 | 0      |
# >> |     問題コメント数 | 0      |
# >> |--------------------+--------|
# >> |---------------------+---------------------------|
# >> |                  id | 28                        |
# >> |            judge_id | 9                         |
# >> |            final_id | 2                         |
# >> |        battle_count | 1                         |
# >> |           win_count | 1                         |
# >> |          lose_count | 0                         |
# >> |            win_rate | 1.0                       |
# >> |              rating | 1516.0                    |
# >> |         rating_diff | 16.0                      |
# >> |          rating_max | 1516.0                    |
# >> |  straight_win_count | 1                         |
# >> | straight_lose_count | 0                         |
# >> |    straight_win_max | 1                         |
# >> |   straight_lose_max | 0                         |
# >> |            skill_id | 43                        |
# >> |         skill_point | 20.0                      |
# >> |     skill_last_diff | 20.0                      |
# >> |          created_at | 2020-06-24 20:25:32 +0900 |
# >> |          updated_at | 2020-06-24 20:25:32 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |             user_id | 18                        |
# >> |           season_id | 23                        |
# >> |        create_count | 2                         |
# >> |          generation | 11                        |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 18                        |
# >> |             user_id | 18                        |
# >> |            judge_id | 12                        |
# >> |            final_id | 5                         |
# >> |        battle_count | 0                         |
# >> |           win_count | 0                         |
# >> |          lose_count | 0                         |
# >> |            win_rate | 0.0                       |
# >> |              rating | 1500.0                    |
# >> |         rating_diff | 0.0                       |
# >> |          rating_max | 1500.0                    |
# >> |  straight_win_count | 0                         |
# >> | straight_lose_count | 0                         |
# >> |    straight_win_max | 0                         |
# >> |   straight_lose_max | 0                         |
# >> |            skill_id | 43                        |
# >> |         skill_point | 0.0                       |
# >> |     skill_last_diff | 0.0                       |
# >> |          created_at | 2020-06-24 20:25:29 +0900 |
# >> |          updated_at | 2020-06-24 20:25:29 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |---------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | 13 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:28 +0900 | 2020-06-24 20:25:28 +0900 |
# >> | 14 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 15 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 16 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 17 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 18 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 19 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 20 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 21 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 22 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> | 23 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id | key                              | user_id | folder_id | lineage_id | init_sfen                                                                | time_limit_sec | difficulty_level | title                  | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | good_rate | moves_answers_count | histories_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | 49 | ef5c5009401cf717ae7e37dd8c834a7d |      18 |        54 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                               |             60 |                1 | はじまりの金           | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:31 +0900 |       0.0 |                   1 |               1 |                1 |               0 |                0 |              5 |
# >> | 50 | a022f1d45ccd3460f6da8008843269e4 |      18 |        53 |         17 | ln1gk2nl/6g2/p2pppspp/2p3p2/7P1/1rP6/P2PPPP1P/2G3SR1/LN2KG1NL b BSPbsp 1 |             60 |                1 | 居玉は危険             |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:31 +0900 |       0.0 |                   1 |               1 |                0 |               1 |                0 |              0 |
# >> | 51 | fa8fc185045af4d329ff13f9a632f156 |      18 |        52 |         15 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1                      |             60 |                1 | 美濃囲いの弱点         |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                1 |              0 |
# >> | 52 | 40085dba3bd506267fd3039dea8ea404 |      18 |        52 |         15 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1                              |             60 |                1 | 斜めに弱い             |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 53 | cbd6adcc26c6ae176a04a92450f2cf27 |      18 |        52 |         15 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1                               |             60 |                1 | 桂馬をうまく使う       |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 54 | 57f055d2775e96b4c1e7e879623993b3 |      18 |        52 |         16 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1                        |             60 |                1 | 棺桶美濃あるある       |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 55 | 84fea0e5c3fba625431e319ac6d7c4f1 |      18 |        52 |         16 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1                        |             60 |                1 | 美濃囲いあるある       |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 56 | 0dcbb33d060d3507dc29f46f23f82643 |      18 |        52 |         15 | ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1                           |             60 |                1 | 成っちゃだめ           |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 57 | b0538a0efd2a8ee173d6fd11160fcf4f |      18 |        52 |         15 | 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1                             |             60 |                1 | 銀の弱点               |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 58 | cba9132a42f676ae206d3017b848b764 |      18 |        52 |         15 | 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1                         |             60 |                1 | 玉をひっぱり上げる     |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 59 | e1dbd0d616511f4a16016595f21f662f |      18 |        52 |         15 | 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1                              |             60 |                1 | はじまりの桂           |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 60 | ed76b107012f82dfa4270c673aa18e5b |      18 |        52 |         15 | ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1                      |             60 |                1 | 致命傷になる玉の早逃げ |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 61 | c4dc5ed464b323fc75d0d872171514ee |      18 |        52 |         15 | lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1               |            180 |                4 | むずいよ               |               |             |                |                   |                  |                     | 2020-06-24 20:25:29 +0900 | 2020-06-24 20:25:29 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 62 | bab5f0812337a44f178e64d0ffda10ca |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-23 20:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 63 | 18933241b9e61ae9475228605559d81a |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-23 21:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 64 | 83b638aea9946a8228cf2b7a43225141 |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-23 22:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 65 | 20e8e99f973208420a604b4e516766fb |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-23 23:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 66 | d31d84168e3a85d42d905053875086dd |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 00:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 67 | bb81d259a8104bdc767fa8e9ddd10a9a |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 01:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 68 | f8d8fbf0177c182d2782084753d70cdd |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 02:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 69 | fce5ac51982b91e389aeec2d35480cc1 |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 03:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 70 | ed9edc7ced42586fdac51f5d3b591753 |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 04:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 71 | 17e556f9db327c3c69052693cae5cadd |      18 |        52 |         15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1                               |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-24 20:25:31 +0900 | 2020-06-24 05:25:31 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     26 |
# >> | Actb::Question         |    23 |     71 |
# >> | Actb::QuestionMessage  |     5 |     17 |
# >> | Actb::Room             |     1 |      7 |
# >> | Actb::RoomMembership   |     2 |     14 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |     11 |
# >> | Actb::BattleMembership |     4 |     22 |
# >> | Actb::Season           |    11 |     23 |
# >> | Actb::SeasonXrecord    |    10 |     28 |
# >> | Actb::Setting          |     9 |     26 |
# >> | Actb::GoodMark         |     1 |      3 |
# >> | Actb::BadMark          |     1 |      4 |
# >> | Actb::ClipMark         |     1 |     33 |
# >> | Actb::Folder           |    27 |     78 |
# >> | Actb::Lineage          |     7 |     21 |
# >> | Actb::Judge            |     4 |     12 |
# >> | Actb::Rule             |     3 |      9 |
# >> | Actb::Skill            |    21 |     63 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
