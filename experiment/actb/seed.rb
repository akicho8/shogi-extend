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
question.folder # => #<Actb::TrashBox id: 426, user_id: 142, type: "Actb::TrashBox", created_at: "2020-06-25 09:35:37", updated_at: "2020-06-25 09:35:37">

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
battle                          # => #<Actb::Battle id: 1, room_id: 1, parent_id: nil, rule_id: 4, final_id: 5, begin_at: "2020-06-25 09:35:40", end_at: nil, battle_pos: 0, created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">

battle.users.count                # => 2
battle.battle_pos               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 2, room_id: 1, parent_id: 1, rule_id: 4, final_id: 5, begin_at: "2020-06-25 09:35:40", end_at: nil, battle_pos: 1, created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">
battle2.battle_pos                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>61, "init_sfen"=>"position sfen ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いの弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*7d 8b9b G*8b", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*7d 8b7a G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>62, "init_sfen"=>"position sfen 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"斜めに弱い", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*2c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>63, "init_sfen"=>"position sfen 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"桂馬をうまく使う", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*2c 1a2a G*3a", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*2c 2b2c G*1b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>64, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"棺桶美濃あるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>65, "init_sfen"=>"position sfen ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いあるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"B*7a 8b9b P*9c 8a9c G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>66, "init_sfen"=>"position sfen ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"成っちゃだめ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*9c 8a9c 8b8a", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>67, "init_sfen"=>"position sfen 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"銀の弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*2b 3a2b G*3b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>68, "init_sfen"=>"position sfen 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"玉をひっぱり上げる", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b2a G*2b", "end_sfen"=>nil}, {"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b1b G*2b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>69, "init_sfen"=>"position sfen 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"はじまりの桂", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*4c", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"N*6c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>70, "init_sfen"=>"position sfen ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"致命傷になる玉の早逃げ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>142, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*7d", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}]

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
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 32, user_id: 142, question_id: 59, body: "message", created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">, #<Actb::QuestionMessage id: 33, user_id: 142, question_id: 59, body: "message", created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">, #<Actb::QuestionMessage id: 34, user_id: 142, question_id: 59, body: "message", created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">, #<Actb::QuestionMessage id: 35, user_id: 142, question_id: 59, body: "message", created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">, #<Actb::QuestionMessage id: 36, user_id: 142, question_id: 59, body: "message", created_at: "2020-06-25 09:35:40", updated_at: "2020-06-25 09:35:40">
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
# >> | 最新シーズン情報ID | 151    |
# >> | 永続的プロフ情報ID | 142    |
# >> |         部屋入室数 | 1      |
# >> |             対局数 | 2      |
# >> |         問題履歴数 | 23     |
# >> |     バトル中発言数 | 0      |
# >> |       ロビー発言数 | 0      |
# >> |     問題コメント数 | 0      |
# >> |       問題高評価率 | 0.0    |
# >> |       問題高評価数 | 0      |
# >> |       問題低評価数 | 0      |
# >> |--------------------+--------|
# >> |---------------------+---------------------------|
# >> |                  id | 151                       |
# >> |            judge_id | 5                         |
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
# >> |            skill_id | 22                        |
# >> |         skill_point | 20.0                      |
# >> |     skill_last_diff | 20.0                      |
# >> |          created_at | 2020-06-25 18:35:40 +0900 |
# >> |          updated_at | 2020-06-25 18:35:40 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |             user_id | 142                       |
# >> |           season_id | 12                        |
# >> |        create_count | 2                         |
# >> |          generation | 11                        |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 142                       |
# >> |             user_id | 142                       |
# >> |            judge_id | 8                         |
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
# >> |            skill_id | 22                        |
# >> |         skill_point | 0.0                       |
# >> |     skill_last_diff | 0.0                       |
# >> |          created_at | 2020-06-25 18:35:37 +0900 |
# >> |          updated_at | 2020-06-25 18:35:37 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |---------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |  2 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:36 +0900 | 2020-06-25 18:35:36 +0900 |
# >> |  3 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  4 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  5 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  6 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  7 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  8 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |  9 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> | 10 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> | 11 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> | 12 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id | key                              | user_id | folder_id | lineage_id | init_sfen                                                                | time_limit_sec | difficulty_level | title                  | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | good_rate | moves_answers_count | histories_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | 59 | ef5c5009401cf717ae7e37dd8c834a7d |     142 |       426 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                               |             60 |                1 | はじまりの金           | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:39 +0900 |       0.0 |                   1 |               1 |                1 |               0 |                0 |              5 |
# >> | 60 | a022f1d45ccd3460f6da8008843269e4 |     142 |       425 |         10 | ln1gk2nl/6g2/p2pppspp/2p3p2/7P1/1rP6/P2PPPP1P/2G3SR1/LN2KG1NL b BSPbsp 1 |             60 |                1 | 居玉は危険             |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:39 +0900 |       0.0 |                   1 |               1 |                0 |               1 |                0 |              0 |
# >> | 61 | fa8fc185045af4d329ff13f9a632f156 |     142 |       424 |          8 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1                      |             60 |                1 | 美濃囲いの弱点         |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                1 |              0 |
# >> | 62 | 40085dba3bd506267fd3039dea8ea404 |     142 |       424 |          8 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1                              |             60 |                1 | 斜めに弱い             |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 63 | cbd6adcc26c6ae176a04a92450f2cf27 |     142 |       424 |          8 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1                               |             60 |                1 | 桂馬をうまく使う       |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 64 | 57f055d2775e96b4c1e7e879623993b3 |     142 |       424 |          9 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1                        |             60 |                1 | 棺桶美濃あるある       |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 65 | 84fea0e5c3fba625431e319ac6d7c4f1 |     142 |       424 |          9 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1                        |             60 |                1 | 美濃囲いあるある       |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 66 | 0dcbb33d060d3507dc29f46f23f82643 |     142 |       424 |          8 | ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1                           |             60 |                1 | 成っちゃだめ           |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 67 | b0538a0efd2a8ee173d6fd11160fcf4f |     142 |       424 |          8 | 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1                             |             60 |                1 | 銀の弱点               |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 68 | cba9132a42f676ae206d3017b848b764 |     142 |       424 |          8 | 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1                         |             60 |                1 | 玉をひっぱり上げる     |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 69 | e1dbd0d616511f4a16016595f21f662f |     142 |       424 |          8 | 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1                              |             60 |                1 | はじまりの桂           |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 70 | ed76b107012f82dfa4270c673aa18e5b |     142 |       424 |          8 | ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1                      |             60 |                1 | 致命傷になる玉の早逃げ |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 71 | c4dc5ed464b323fc75d0d872171514ee |     142 |       424 |          8 | lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1               |            180 |                4 | むずいよ               |               |             |                |                   |                  |                     | 2020-06-25 18:35:37 +0900 | 2020-06-25 18:35:37 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 72 | 267255cecff069dac5827e1d57b0561b |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 18:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 73 | cb250f521179e50289d94229d2a96928 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 19:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 74 | dec6103c0d876110a8c80b44599f4526 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 20:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 75 | ae8e3f7e413e44e64fd9ee2e25d44b9c |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 21:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 76 | 696392f96171b3c1273e87ed6a1ea52c |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 22:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 77 | 1e952629d17bc032e7a368f6b651d918 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-24 23:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 78 | ef77ca893fbf284545479399c2cf9a62 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-25 00:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 79 | c8426a6f3433b96dea40a32ff359d58e |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-25 01:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 80 | 6051b1b7960eb9796f87726bfe90c922 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-25 02:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 81 | afd9b5c7fe3638e92dbb1b7c5d3838b5 |     142 |       424 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1                               |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-25 18:35:39 +0900 | 2020-06-25 03:35:39 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |    150 |
# >> | Actb::Question         |    23 |     81 |
# >> | Actb::QuestionMessage  |     5 |     36 |
# >> | Actb::Room             |     1 |      1 |
# >> | Actb::RoomMembership   |     2 |      2 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |      2 |
# >> | Actb::BattleMembership |     4 |      4 |
# >> | Actb::Season           |    11 |     12 |
# >> | Actb::SeasonXrecord    |    10 |    151 |
# >> | Actb::Setting          |     9 |    150 |
# >> | Actb::GoodMark         |     1 |     18 |
# >> | Actb::BadMark          |     1 |      1 |
# >> | Actb::ClipMark         |     1 |      1 |
# >> | Actb::Folder           |    27 |    450 |
# >> | Actb::Lineage          |     7 |     14 |
# >> | Actb::Judge            |     4 |      8 |
# >> | Actb::Rule             |     3 |      6 |
# >> | Actb::Skill            |    21 |     42 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
