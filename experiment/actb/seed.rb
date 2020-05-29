require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

Actb::Lineage.all.collect(&:key)                 # => ["詰将棋", "実戦詰め筋", "手筋", "必死", "必死逃れ", "定跡", "秘密"]

10.times do
  Actb::Season.create!
end

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
question.folder # => #<Actb::TrashBox id: 210, user_id: 70, type: "Actb::TrashBox", created_at: "2020-05-28 14:50:11", updated_at: "2020-05-28 14:50:11">

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

battle.users.count                # => 2
battle.rensen_index               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 10, room_id: 5, parent_id: 9, begin_at: "2020-05-28 14:50:13", end_at: nil, final_key: nil, rule_key: "marathon_rule", rensen_index: 1, created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">
battle2.rensen_index                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>15, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_description"=>"(hint_description)", "source_desc"=>"(source_desc)", "other_twitter_account"=>"(other_twitter_account)", "user"=>{"id"=>70, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ox_mark_key = Actb::OxMarkInfo[i.modulo(Actb::OxMarkInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ox_mark: Actb::OxMark.fetch(ox_mark_key))
end

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

# 問題に対してコメント
5.times do
  question = Actb::Question.first!
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 8, user_id: 70, question_id: 13, body: "message", created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">, #<Actb::QuestionMessage id: 9, user_id: 70, question_id: 13, body: "message", created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">, #<Actb::QuestionMessage id: 10, user_id: 70, question_id: 13, body: "message", created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">, #<Actb::QuestionMessage id: 11, user_id: 70, question_id: 13, body: "message", created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">, #<Actb::QuestionMessage id: 12, user_id: 70, question_id: 13, body: "message", created_at: "2020-05-28 14:50:13", updated_at: "2020-05-28 14:50:13">
  question.messages_count                    # => 1, 2, 3, 4, 5
end

tp Actb::Question

tp Actb.info
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> | id | user_id | folder_id | lineage_id | init_sfen                                 | time_limit_sec | difficulty_level | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clip_marks_count | messages_count |
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> | 13 |      70 |       210 |         36 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-28 23:50:13 +0900 | 2020-05-28 23:50:13 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                1 |                0 |              5 |
# >> | 14 |      70 |       209 |         36 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-28 23:50:13 +0900 | 2020-05-28 23:50:13 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               1 |                0 |                0 |              0 |
# >> | 15 |      70 |       208 |         36 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-28 23:50:13 +0900 | 2020-05-28 01:50:13 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |                1 |              0 |
# >> |----+---------+-----------+------------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | Colosseum::User        |    14 |     83 |
# >> | Actb::Question         |     3 |     15 |
# >> | Actb::Room             |     1 |      5 |
# >> | Actb::RoomMembership   |     2 |     10 |
# >> | Actb::Battle           |     2 |     10 |
# >> | Actb::BattleMembership |     4 |     20 |
# >> | Actb::Season           |    11 |     56 |
# >> | Actb::Profile          |    14 |     83 |
# >> | Actb::Setting          |    14 |     83 |
# >> | Actb::GoodMark         |     1 |      5 |
# >> | Actb::BadMark          |     1 |      5 |
# >> | Actb::ClipMark         |     1 |      5 |
# >> | Actb::Folder           |    42 |    249 |
# >> | Actb::Lineage          |     7 |     42 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::QuestionMessage  |     5 |     12 |
# >> |------------------------+-------+--------|
