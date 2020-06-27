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
question.folder # => #<Actb::TrashBox id: 120, user_id: 40, type: "Actb::TrashBox", created_at: "2020-06-27 08:08:01", updated_at: "2020-06-27 08:08:01">

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
battle                          # => #<Actb::Battle id: 194, room_id: 134, parent_id: nil, rule_id: 13, final_id: 5, begin_at: "2020-06-27 08:08:17", end_at: nil, battle_pos: 0, created_at: "2020-06-27 08:08:17", updated_at: "2020-06-27 08:08:17">

battle.users.count                # => 2
battle.battle_pos               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 195, room_id: 134, parent_id: 194, rule_id: 13, final_id: 5, begin_at: "2020-06-27 08:08:17", end_at: nil, battle_pos: 1, created_at: "2020-06-27 08:08:17", updated_at: "2020-06-27 08:08:17">
battle2.battle_pos                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>88, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"棺桶美濃あるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>89, "init_sfen"=>"position sfen ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いあるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"B*7a 8b9b P*9c 8a9c G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>91, "init_sfen"=>"position sfen 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"銀の弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*2b 3a2b G*3b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>94, "init_sfen"=>"position sfen ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"致命傷になる玉の早逃げ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*7d", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>95, "init_sfen"=>"position sfen lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1", "time_limit_sec"=>180, "difficulty_level"=>4, "title"=>"むずいよ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>11, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 6a7b G*6c 7b8b 6b7a 8b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b6a G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>99, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>102, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>103, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>104, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>105, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>40, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0001_fallback_avatar_icon-1c979075c13ff421e26ac7327e92d200413c01d4b6304fb107324b1a3e642eaf.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}]

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
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 16, user_id: 40, question_id: 83, body: "message", created_at: "2020-06-27 08:08:18", updated_at: "2020-06-27 08:08:18">, #<Actb::QuestionMessage id: 17, user_id: 40, question_id: 83, body: "message", created_at: "2020-06-27 08:08:18", updated_at: "2020-06-27 08:08:18">, #<Actb::QuestionMessage id: 18, user_id: 40, question_id: 83, body: "message", created_at: "2020-06-27 08:08:19", updated_at: "2020-06-27 08:08:19">, #<Actb::QuestionMessage id: 19, user_id: 40, question_id: 83, body: "message", created_at: "2020-06-27 08:08:20", updated_at: "2020-06-27 08:08:20">, #<Actb::QuestionMessage id: 20, user_id: 40, question_id: 83, body: "message", created_at: "2020-06-27 08:08:20", updated_at: "2020-06-27 08:08:20">
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
# >> | 最新シーズン情報ID | 52     |
# >> | 永続的プロフ情報ID | 40     |
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
# >> |                  id | 52                        |
# >> |            judge_id | 17                        |
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
# >> |            skill_id | 85                        |
# >> |         skill_point | 20.0                      |
# >> |     skill_last_diff | 20.0                      |
# >> |          created_at | 2020-06-27 17:08:18 +0900 |
# >> |          updated_at | 2020-06-27 17:08:18 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |             user_id | 40                        |
# >> |           season_id | 45                        |
# >> |        create_count | 2                         |
# >> |          generation | 11                        |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 40                        |
# >> |             user_id | 40                        |
# >> |            judge_id | 20                        |
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
# >> |            skill_id | 85                        |
# >> |         skill_point | 0.0                       |
# >> |     skill_last_diff | 0.0                       |
# >> |          created_at | 2020-06-27 17:08:01 +0900 |
# >> |          updated_at | 2020-06-27 17:08:01 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |---------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | 35 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:01 +0900 | 2020-06-27 17:08:01 +0900 |
# >> | 36 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 37 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 38 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 39 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 40 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 41 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 42 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 43 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 44 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> | 45 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id  | key                              | user_id | folder_id | lineage_id | init_sfen                                                                | time_limit_sec | difficulty_level | title                  | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | good_rate | moves_answers_count | histories_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |  83 | ef5c5009401cf717ae7e37dd8c834a7d |      40 |       120 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                               |             60 |                1 | はじまりの金           | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:01 +0900 | 2020-06-27 17:08:17 +0900 |       0.0 |                   1 |               1 |                1 |               0 |                0 |              5 |
# >> |  84 | a022f1d45ccd3460f6da8008843269e4 |      40 |       119 |         31 | ln1gk2nl/6g2/p2pppspp/2p3p2/7P1/1rP6/P2PPPP1P/2G3SR1/LN2KG1NL b BSPbsp 1 |             60 |                1 | 居玉は危険             |               |             |                |                   |                  |                     | 2020-06-27 17:08:02 +0900 | 2020-06-27 17:08:17 +0900 |       0.0 |                   1 |               1 |                0 |               1 |                0 |              0 |
# >> |  85 | fa8fc185045af4d329ff13f9a632f156 |      40 |       118 |         29 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1                      |             60 |                1 | 美濃囲いの弱点         |               |             |                |                   |                  |                     | 2020-06-27 17:08:03 +0900 | 2020-06-27 17:08:03 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                1 |              0 |
# >> |  86 | 40085dba3bd506267fd3039dea8ea404 |      40 |       118 |         29 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1                              |             60 |                1 | 斜めに弱い             |               |             |                |                   |                  |                     | 2020-06-27 17:08:03 +0900 | 2020-06-27 17:08:03 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> |  87 | cbd6adcc26c6ae176a04a92450f2cf27 |      40 |       118 |         29 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1                               |             60 |                1 | 桂馬をうまく使う       |               |             |                |                   |                  |                     | 2020-06-27 17:08:04 +0900 | 2020-06-27 17:08:04 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> |  88 | 57f055d2775e96b4c1e7e879623993b3 |      40 |       118 |         30 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1                        |             60 |                1 | 棺桶美濃あるある       |               |             |                |                   |                  |                     | 2020-06-27 17:08:04 +0900 | 2020-06-27 17:08:04 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> |  89 | 84fea0e5c3fba625431e319ac6d7c4f1 |      40 |       118 |         30 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1                        |             60 |                1 | 美濃囲いあるある       |               |             |                |                   |                  |                     | 2020-06-27 17:08:05 +0900 | 2020-06-27 17:08:05 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> |  90 | 0dcbb33d060d3507dc29f46f23f82643 |      40 |       118 |         29 | ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1                           |             60 |                1 | 成っちゃだめ           |               |             |                |                   |                  |                     | 2020-06-27 17:08:06 +0900 | 2020-06-27 17:08:06 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> |  91 | b0538a0efd2a8ee173d6fd11160fcf4f |      40 |       118 |         29 | 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1                             |             60 |                1 | 銀の弱点               |               |             |                |                   |                  |                     | 2020-06-27 17:08:06 +0900 | 2020-06-27 17:08:06 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> |  92 | cba9132a42f676ae206d3017b848b764 |      40 |       118 |         29 | 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1                         |             60 |                1 | 玉をひっぱり上げる     |               |             |                |                   |                  |                     | 2020-06-27 17:08:07 +0900 | 2020-06-27 17:08:07 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> |  93 | e1dbd0d616511f4a16016595f21f662f |      40 |       118 |         29 | 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1                              |             60 |                1 | はじまりの桂           |               |             |                |                   |                  |                     | 2020-06-27 17:08:07 +0900 | 2020-06-27 17:08:07 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> |  94 | ed76b107012f82dfa4270c673aa18e5b |      40 |       118 |         29 | ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1                      |             60 |                1 | 致命傷になる玉の早逃げ |               |             |                |                   |                  |                     | 2020-06-27 17:08:08 +0900 | 2020-06-27 17:08:08 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> |  95 | c4dc5ed464b323fc75d0d872171514ee |      40 |       118 |         29 | lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1               |            180 |                4 | むずいよ               |               |             |                |                   |                  |                     | 2020-06-27 17:08:09 +0900 | 2020-06-27 17:08:09 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |  96 | 0421573d6c46f0a12e99b0166258f4a1 |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:11 +0900 | 2020-06-26 17:08:11 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |  97 | 937c13718b13186d3cae14b30aa200a9 |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 17:08:11 +0900 | 2020-06-26 18:08:11 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |  98 | b996069f4c52d71facf51a457f6ddbdd |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:12 +0900 | 2020-06-26 19:08:12 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |  99 | 03153570207f898dd12d692517edb55f |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 17:08:13 +0900 | 2020-06-26 20:08:13 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 100 | ecda06cdfe56705fc97e94ab69b80fdc |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:13 +0900 | 2020-06-26 21:08:13 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 101 | 2da1474a20925edecad9d8b4555abf9e |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 17:08:14 +0900 | 2020-06-26 22:08:14 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 102 | c177b0cbc9e07b8e56cb374b8d4bd6d5 |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:14 +0900 | 2020-06-26 23:08:14 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 103 | 79b0521486a6f6df2c611b99a2e6a9c8 |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 17:08:15 +0900 | 2020-06-27 00:08:15 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 104 | cca11702e8f858f208b0a8a4ff1a417c |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1                                |            180 |                5 | (title)                | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-27 17:08:16 +0900 | 2020-06-27 01:08:16 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 105 | 055a9e3c87e58b9596ac12ce9ed1c984 |      40 |       118 |         29 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1                               |            180 |                5 | (title)                | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-27 17:08:16 +0900 | 2020-06-27 02:08:16 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     48 |
# >> | Actb::Question         |    23 |    105 |
# >> | Actb::QuestionMessage  |     5 |     20 |
# >> | Actb::Room             |     1 |    134 |
# >> | Actb::RoomMembership   |     2 |    268 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |    195 |
# >> | Actb::BattleMembership |     4 |    390 |
# >> | Actb::Season           |    11 |     45 |
# >> | Actb::SeasonXrecord    |    10 |     52 |
# >> | Actb::MainXrecord      |     9 |     48 |
# >> | Actb::Setting          |     9 |     48 |
# >> | Actb::GoodMark         |     1 |      4 |
# >> | Actb::BadMark          |     1 |      4 |
# >> | Actb::ClipMark         |     1 |      4 |
# >> | Actb::Folder           |    27 |    144 |
# >> | Actb::Lineage          |     7 |     35 |
# >> | Actb::Judge            |     4 |     20 |
# >> | Actb::Rule             |     3 |     15 |
# >> | Actb::Skill            |    21 |    105 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
