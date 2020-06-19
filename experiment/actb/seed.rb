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
Actb::Question.count           # => 16

question = Actb::Question.first!
question.lineage.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 225, user_id: 75, type: "Actb::TrashBox", created_at: "2020-06-16 14:48:18", updated_at: "2020-06-16 14:48:18">

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
battle                          # => #<Actb::Battle id: 15, room_id: 8, parent_id: nil, rule_id: 34, final_id: 5, begin_at: "2020-06-16 14:48:21", end_at: nil, rensen_index: 0, created_at: "2020-06-16 14:48:21", updated_at: "2020-06-16 14:48:21">

battle.users.count                # => 2
battle.rensen_index               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 16, room_id: 8, parent_id: 15, rule_id: 34, final_id: 5, begin_at: "2020-06-16 14:48:21", end_at: nil, rensen_index: 1, created_at: "2020-06-16 14:48:21", updated_at: "2020-06-16 14:48:21">
battle2.rensen_index                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>139, "init_sfen"=>"position sfen 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1", "time_limit_sec"=>10, "difficulty_level"=>1, "title"=>"斜めに弱い", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"{:moves_str=>\"{:moves_str=>\\\"N*2c\\\"}\"}", "end_sfen"=>nil}]}, {"id"=>141, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>10, "difficulty_level"=>1, "title"=>"美濃囲いあるある詰め筋1", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"{:moves_str=>\"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c\"}", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"{:moves_str=>\"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b\"}", "end_sfen"=>nil}]}, {"id"=>142, "init_sfen"=>"position sfen ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1", "time_limit_sec"=>10, "difficulty_level"=>1, "title"=>"美濃囲いあるある詰め筋2", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"{:moves_str=>\"B*7a 8b9b P*9c 8a9c G*8b\"}", "end_sfen"=>nil}]}, {"id"=>144, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>145, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>146, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>149, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>150, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>151, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}, {"id"=>152, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>75, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0000_fallback_avatar_icon-9fae4951044e65f781d23aefc5283c381e271401a491db66138690cec948c841.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

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
battle.katimake_set(user1, :win, :f_success)

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
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 21, user_id: 75, question_id: 137, body: "message", created_at: "2020-06-16 14:48:22", updated_at: "2020-06-16 14:48:22">, #<Actb::QuestionMessage id: 22, user_id: 75, question_id: 137, body: "message", created_at: "2020-06-16 14:48:22", updated_at: "2020-06-16 14:48:22">, #<Actb::QuestionMessage id: 23, user_id: 75, question_id: 137, body: "message", created_at: "2020-06-16 14:48:22", updated_at: "2020-06-16 14:48:22">, #<Actb::QuestionMessage id: 24, user_id: 75, question_id: 137, body: "message", created_at: "2020-06-16 14:48:22", updated_at: "2020-06-16 14:48:22">, #<Actb::QuestionMessage id: 25, user_id: 75, question_id: 137, body: "message", created_at: "2020-06-16 14:48:22", updated_at: "2020-06-16 14:48:22">
  question.messages_count                    # => 1, 2, 3, 4, 5
end

tp Actb::Season
tp Actb::Question

tp Actb.info
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
# >> |--------------------+--------|
# >> |               名前 | 運営   |
# >> |       レーティング | 1500.0 |
# >> |             クラス | C-     |
# >> |         作成問題数 | 16     |
# >> | 最新シーズン情報ID | 96     |
# >> | 永続的プロフ情報ID | 75     |
# >> |         部屋入室数 | 1      |
# >> |             対局数 | 2      |
# >> |         問題履歴数 | 16     |
# >> |     バトル中発言数 | 0      |
# >> |       ロビー発言数 | 0      |
# >> |     問題コメント数 | 0      |
# >> |--------------------+--------|
# >> |------------------+---------------------------|
# >> |               id | 96                        |
# >> |         judge_id | 45                        |
# >> |         final_id | 2                         |
# >> |     battle_count | 1                         |
# >> |        win_count | 1                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 1.0                       |
# >> |           rating | 1516.0                    |
# >> | rating_diff | 16.0                      |
# >> |       rating_max | 1516.0                    |
# >> |     rensho_count | 1                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 1                         |
# >> |       renpai_max | 0                         |
# >> |        udemae_id | 232                       |
# >> |     udemae_point | 20.0                      |
# >> |       created_at | 2020-06-16 23:48:21 +0900 |
# >> |       updated_at | 2020-06-16 23:48:22 +0900 |
# >> | disconnect_count | 0                         |
# >> |  disconnected_at |                           |
# >> |          user_id | 75                        |
# >> |        season_id | 95                        |
# >> |     create_count | 2                         |
# >> |       generation | 11                        |
# >> |------------------+---------------------------|
# >> |------------------+---------------------------|
# >> |               id | 75                        |
# >> |          user_id | 75                        |
# >> |         judge_id | 48                        |
# >> |         final_id | 5                         |
# >> |     battle_count | 0                         |
# >> |        win_count | 0                         |
# >> |       lose_count | 0                         |
# >> |         win_rate | 0.0                       |
# >> |           rating | 1500.0                    |
# >> | rating_diff | 0.0                       |
# >> |       rating_max | 1500.0                    |
# >> |     rensho_count | 0                         |
# >> |     renpai_count | 0                         |
# >> |       rensho_max | 0                         |
# >> |       renpai_max | 0                         |
# >> |        udemae_id | 232                       |
# >> |     udemae_point | 0.0                       |
# >> |       created_at | 2020-06-16 23:48:18 +0900 |
# >> |       updated_at | 2020-06-16 23:48:18 +0900 |
# >> | disconnect_count | 0                         |
# >> |  disconnected_at |                           |
# >> |------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | 85 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:18 +0900 |
# >> | 86 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 87 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 88 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 89 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 90 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 91 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 92 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 93 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 94 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> | 95 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |-----+----------------------------------+---------+-----------+------------+-----------------------------------------------------+----------------+------------------+-------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id  | key                              | user_id | folder_id | lineage_id | init_sfen                                           | time_limit_sec | difficulty_level | title                   | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |-----+----------------------------------+---------+-----------+------------+-----------------------------------------------------+----------------+------------------+-------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | 137 | ef5c5009401cf717ae7e37dd8c834a7d |      75 |       225 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1          |             10 |                1 | はじまりの金            | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:21 +0900 |                   1 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                1 |               0 |                0 |              5 |
# >> | 138 | fa8fc185045af4d329ff13f9a632f156 |      75 |       224 |         78 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1 |             10 |                1 | 美濃囲いの弱点          |               |             |                |                   |                  |                     | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:21 +0900 |                   2 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               1 |                0 |              0 |
# >> | 139 | 40085dba3bd506267fd3039dea8ea404 |      75 |       223 |         78 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1         |             10 |                1 | 斜めに弱い              |               |             |                |                   |                  |                     | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:18 +0900 |                   1 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                1 |              0 |
# >> | 140 | cbd6adcc26c6ae176a04a92450f2cf27 |      75 |       223 |         78 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1          |             10 |                1 | 桂馬をうまく使う        |               |             |                |                   |                  |                     | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:18 +0900 |                   2 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 141 | 57f055d2775e96b4c1e7e879623993b3 |      75 |       223 |         79 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1   |             10 |                1 | 美濃囲いあるある詰め筋1 |               |             |                |                   |                  |                     | 2020-06-16 23:48:18 +0900 | 2020-06-16 23:48:18 +0900 |                   2 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 142 | 84fea0e5c3fba625431e319ac6d7c4f1 |      75 |       223 |         79 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1   |             10 |                1 | 美濃囲いあるある詰め筋2 |               |             |                |                   |                  |                     | 2020-06-16 23:48:19 +0900 | 2020-06-16 23:48:19 +0900 |                   1 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 143 | 55ff739b0752cdba9c2b092a9194ecef |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-15 23:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 144 | c17b6f3b28146da7efba427c3a76e1e8 |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-16 00:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 145 | 0a4ceab74bd36296990e794537502787 |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-16 01:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 146 | e16df5b4ae7db88280b47309cc9fa320 |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-16 02:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 147 | e04d7053728aa80c34fef806fbff5469 |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-16 03:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 148 | 1a00f74a555e9ef02dc426cdd5fce7ed |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-16 23:48:20 +0900 | 2020-06-16 04:48:20 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 149 | 3fed8f7c44a4ebd83440bbee26e60cbd |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:21 +0900 | 2020-06-16 05:48:21 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 150 | b86096296dd9e0056cfd56446858637c |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-16 23:48:21 +0900 | 2020-06-16 06:48:21 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 151 | 5dcdd2f32aa674104174c8a6d2e4c61a |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1           |            180 |                5 | (title)                 | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-16 23:48:21 +0900 | 2020-06-16 07:48:21 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> | 152 | d926cf77f6815a86e23003d2c389698a |      75 |       223 |         78 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1          |            180 |                5 | (title)                 | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-16 23:48:21 +0900 | 2020-06-16 08:48:21 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |                0 |               0 |                0 |              0 |
# >> |-----+----------------------------------+---------+-----------+------------+-----------------------------------------------------+----------------+------------------+-------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     83 |
# >> | Actb::Question         |    16 |    152 |
# >> | Actb::QuestionMessage  |     5 |     25 |
# >> | Actb::Room             |     1 |      8 |
# >> | Actb::RoomMembership   |     2 |     16 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |     16 |
# >> | Actb::BattleMembership |     4 |     32 |
# >> | Actb::Season           |    11 |     95 |
# >> | Actb::SeasonXrecord    |    10 |     96 |
# >> | Actb::Setting          |     9 |     83 |
# >> | Actb::GoodMark         |     1 |      5 |
# >> | Actb::BadMark          |     1 |      5 |
# >> | Actb::ClipMark         |     1 |      5 |
# >> | Actb::Folder           |    27 |    249 |
# >> | Actb::Lineage          |     7 |     84 |
# >> | Actb::Judge            |     4 |     48 |
# >> | Actb::Rule             |     3 |     36 |
# >> | Actb::Udemae           |    21 |    252 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
