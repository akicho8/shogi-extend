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
question.folder # => #<Actb::TrashBox id: 39, user_id: 13, type: "Actb::TrashBox", created_at: "2020-06-27 06:31:59", updated_at: "2020-06-27 06:31:59">

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
battle                          # => #<Actb::Battle id: 7, room_id: 5, parent_id: nil, rule_id: 4, final_id: 5, begin_at: "2020-06-27 06:32:18", end_at: nil, battle_pos: 0, created_at: "2020-06-27 06:32:18", updated_at: "2020-06-27 06:32:18">

battle.users.count                # => 2
battle.battle_pos               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 8, room_id: 5, parent_id: 7, rule_id: 4, final_id: 5, begin_at: "2020-06-27 06:32:18", end_at: nil, battle_pos: 1, created_at: "2020-06-27 06:32:18", updated_at: "2020-06-27 06:32:18">
battle2.battle_pos                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>18, "init_sfen"=>"position sfen 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"桂馬をうまく使う", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*2c 1a2a G*3a", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*2c 2b2c G*1b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>19, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"棺桶美濃あるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>21, "init_sfen"=>"position sfen ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"成っちゃだめ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*9c 8a9c 8b8a", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>22, "init_sfen"=>"position sfen 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"銀の弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*2b 3a2b G*3b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>23, "init_sfen"=>"position sfen 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"玉をひっぱり上げる", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b2a G*2b", "end_sfen"=>nil}, {"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b1b G*2b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>24, "init_sfen"=>"position sfen 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"はじまりの桂", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*4c", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"N*6c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>26, "init_sfen"=>"position sfen lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1", "time_limit_sec"=>180, "difficulty_level"=>4, "title"=>"むずいよ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>11, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 6a7b G*6c 7b8b 6b7a 8b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b6a G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>27, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>30, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>33, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>13, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0006_fallback_avatar_icon-f07410f5866412fbc17e58a262b07e419a5d8724e300c69c85ea026433163513.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}]

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
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 1, user_id: 13, question_id: 14, body: "message", created_at: "2020-06-27 06:32:18", updated_at: "2020-06-27 06:32:18">, #<Actb::QuestionMessage id: 2, user_id: 13, question_id: 14, body: "message", created_at: "2020-06-27 06:32:19", updated_at: "2020-06-27 06:32:19">, #<Actb::QuestionMessage id: 3, user_id: 13, question_id: 14, body: "message", created_at: "2020-06-27 06:32:20", updated_at: "2020-06-27 06:32:20">, #<Actb::QuestionMessage id: 4, user_id: 13, question_id: 14, body: "message", created_at: "2020-06-27 06:32:20", updated_at: "2020-06-27 06:32:20">, #<Actb::QuestionMessage id: 5, user_id: 13, question_id: 14, body: "message", created_at: "2020-06-27 06:32:21", updated_at: "2020-06-27 06:32:21">
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
# >> | 最新シーズン情報ID | 22     |
# >> | 永続的プロフ情報ID | 13     |
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
# >> |                  id | 22                        |
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
# >> |          created_at | 2020-06-27 15:32:18 +0900 |
# >> |          updated_at | 2020-06-27 15:32:18 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |             user_id | 13                        |
# >> |           season_id | 12                        |
# >> |        create_count | 2                         |
# >> |          generation | 11                        |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 13                        |
# >> |             user_id | 13                        |
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
# >> |          created_at | 2020-06-27 15:31:59 +0900 |
# >> |          updated_at | 2020-06-27 15:31:59 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |---------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |  2 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:31:59 +0900 | 2020-06-27 15:31:59 +0900 |
# >> |  3 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  4 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  5 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  6 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  7 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  8 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |  9 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> | 10 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> | 11 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> | 12 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id | key                              | user_id | folder_id | lineage_id | init_sfen                                                                | time_limit_sec | difficulty_level | title                  | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | good_rate | moves_answers_count | histories_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | 14 | ef5c5009401cf717ae7e37dd8c834a7d |      13 |        39 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                               |             60 |                1 | はじまりの金           | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:31:59 +0900 | 2020-06-27 15:32:17 +0900 |       0.0 |                   1 |               1 |                1 |               0 |                0 |              5 |
# >> | 15 | a022f1d45ccd3460f6da8008843269e4 |      13 |        38 |         10 | ln1gk2nl/6g2/p2pppspp/2p3p2/7P1/1rP6/P2PPPP1P/2G3SR1/LN2KG1NL b BSPbsp 1 |             60 |                1 | 居玉は危険             |               |             |                |                   |                  |                     | 2020-06-27 15:32:00 +0900 | 2020-06-27 15:32:17 +0900 |       0.0 |                   1 |               1 |                0 |               1 |                0 |              0 |
# >> | 16 | fa8fc185045af4d329ff13f9a632f156 |      13 |        37 |          8 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1                      |             60 |                1 | 美濃囲いの弱点         |               |             |                |                   |                  |                     | 2020-06-27 15:32:01 +0900 | 2020-06-27 15:32:01 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                1 |              0 |
# >> | 17 | 40085dba3bd506267fd3039dea8ea404 |      13 |        37 |          8 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1                              |             60 |                1 | 斜めに弱い             |               |             |                |                   |                  |                     | 2020-06-27 15:32:01 +0900 | 2020-06-27 15:32:01 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 18 | cbd6adcc26c6ae176a04a92450f2cf27 |      13 |        37 |          8 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1                               |             60 |                1 | 桂馬をうまく使う       |               |             |                |                   |                  |                     | 2020-06-27 15:32:02 +0900 | 2020-06-27 15:32:02 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 19 | 57f055d2775e96b4c1e7e879623993b3 |      13 |        37 |          9 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1                        |             60 |                1 | 棺桶美濃あるある       |               |             |                |                   |                  |                     | 2020-06-27 15:32:03 +0900 | 2020-06-27 15:32:03 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 20 | 84fea0e5c3fba625431e319ac6d7c4f1 |      13 |        37 |          9 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1                        |             60 |                1 | 美濃囲いあるある       |               |             |                |                   |                  |                     | 2020-06-27 15:32:04 +0900 | 2020-06-27 15:32:04 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 21 | 0dcbb33d060d3507dc29f46f23f82643 |      13 |        37 |          8 | ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1                           |             60 |                1 | 成っちゃだめ           |               |             |                |                   |                  |                     | 2020-06-27 15:32:04 +0900 | 2020-06-27 15:32:04 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 22 | b0538a0efd2a8ee173d6fd11160fcf4f |      13 |        37 |          8 | 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1                             |             60 |                1 | 銀の弱点               |               |             |                |                   |                  |                     | 2020-06-27 15:32:05 +0900 | 2020-06-27 15:32:05 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 23 | cba9132a42f676ae206d3017b848b764 |      13 |        37 |          8 | 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1                         |             60 |                1 | 玉をひっぱり上げる     |               |             |                |                   |                  |                     | 2020-06-27 15:32:05 +0900 | 2020-06-27 15:32:05 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 24 | e1dbd0d616511f4a16016595f21f662f |      13 |        37 |          8 | 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1                              |             60 |                1 | はじまりの桂           |               |             |                |                   |                  |                     | 2020-06-27 15:32:06 +0900 | 2020-06-27 15:32:06 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 25 | ed76b107012f82dfa4270c673aa18e5b |      13 |        37 |          8 | ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1                      |             60 |                1 | 致命傷になる玉の早逃げ |               |             |                |                   |                  |                     | 2020-06-27 15:32:07 +0900 | 2020-06-27 15:32:07 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 26 | c4dc5ed464b323fc75d0d872171514ee |      13 |        37 |          8 | lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1               |            180 |                4 | むずいよ               |               |             |                |                   |                  |                     | 2020-06-27 15:32:08 +0900 | 2020-06-27 15:32:08 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 27 | b286befd4b99fd40cb76a95a02925e51 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:32:10 +0900 | 2020-06-26 15:32:10 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 28 | f54424544dc94ff0504ee999442cdb65 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 15:32:10 +0900 | 2020-06-26 16:32:10 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 29 | d28e5dc753536200837197dd8c624a4a |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:32:11 +0900 | 2020-06-26 17:32:11 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 30 | c75da23e025277e1b94ab957e6d8f4e6 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 15:32:12 +0900 | 2020-06-26 18:32:12 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 31 | 05df509bd6a41a9cb5f0447a06974ace |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:32:13 +0900 | 2020-06-26 19:32:13 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 32 | d053b12cc9c1ff22469637fa462aa8dc |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 15:32:14 +0900 | 2020-06-26 20:32:14 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 33 | 37fe0d6263b2056a52beb4eed0d6f9f1 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:32:15 +0900 | 2020-06-26 21:32:15 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 34 | a733777547213b37dd61880c140aedf5 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 15:32:15 +0900 | 2020-06-26 22:32:15 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 35 | 4448d139d528d6b20ae83e305f3bc891 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 15:32:16 +0900 | 2020-06-26 23:32:16 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 36 | 31c4ce8a285e10949be3c97be0d40591 |      13 |        37 |          8 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1                               |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 15:32:17 +0900 | 2020-06-27 00:32:17 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     21 |
# >> | Actb::Question         |    23 |     36 |
# >> | Actb::QuestionMessage  |     5 |      5 |
# >> | Actb::Room             |     1 |      5 |
# >> | Actb::RoomMembership   |     2 |     10 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |      8 |
# >> | Actb::BattleMembership |     4 |     16 |
# >> | Actb::Season           |    11 |     12 |
# >> | Actb::SeasonXrecord    |    10 |     22 |
# >> | Actb::Setting          |     9 |     21 |
# >> | Actb::GoodMark         |     1 |      1 |
# >> | Actb::BadMark          |     1 |      1 |
# >> | Actb::ClipMark         |     1 |      1 |
# >> | Actb::Folder           |    27 |     63 |
# >> | Actb::Lineage          |     7 |     14 |
# >> | Actb::Judge            |     4 |      8 |
# >> | Actb::Rule             |     3 |      6 |
# >> | Actb::Skill            |    21 |     42 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
