require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

Actb::Kind.all.collect(&:key)                 # => ["詰将棋", "手筋"]

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
question.kind.key               # => "詰将棋"

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 195, user_id: 65, type: "Actb::TrashBox", created_at: "2020-05-19 13:12:37", updated_at: "2020-05-19 13:12:37">

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
membership = room.memberships.first

# 出題
room.best_questions             # => [{"id"=>15, "init_sfen"=>"4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title)", "description"=>"(description)", "hint_description"=>"(hint_description)", "source_desc"=>"(source_desc)", "other_twitter_account"=>"(other_twitter_account)", "user"=>{"id"=>65, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0005_fallback_avatar_icon-acde5a972cba71490139455574a35d908e0b3fe25535de9a39e2d98beae4b0aa.png"}, "moves_answers"=>[{"limit_turn"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"limit_turn"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"limit_turn"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}]}]

# すべての問題に解答する
Actb::Question.all.each.with_index do |question, i|
  ans_result_key = Actb::AnsResultInfo[i.modulo(Actb::AnsResultInfo.count)].key
  user1.actb_histories.create!(membership: membership, question: question, ans_result: Actb::AnsResult.fetch(ans_result_key))
end

# Good, Bad, Clip
user1.actb_good_marks.create!(question: Actb::Question.first!)
user1.actb_bad_marks.create!(question: Actb::Question.second!)
user1.actb_clip_marks.create!(question: Actb::Question.third!)

tp Actb::Question

tp Actb.info
# >> |----+---------+-----------+---------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> | id | user_id | folder_id | kind_id | init_sfen                                 | time_limit_sec | difficulty_level | title   | description   | hint_description   | source_desc   | other_twitter_account   | created_at                | updated_at                | moves_answers_count | endpos_answers_count | o_count | x_count | bad_count | good_count | histories_count | favorites_count | bad_marks_count | good_marks_count | clip_marks_count |
# >> |----+---------+-----------+---------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> | 13 |      65 |       195 |      15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 22:12:39 +0900 | 2020-05-19 22:12:39 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                1 |                0 |
# >> | 14 |      65 |       194 |      15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 22:12:39 +0900 | 2020-05-19 22:12:39 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               1 |                0 |                0 |
# >> | 15 |      65 |       193 |      15 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1 |            180 |                5 | (title) | (description) | (hint_description) | (source_desc) | (other_twitter_account) | 2020-05-19 22:12:39 +0900 | 2020-05-19 00:12:39 +0900 |                   3 |                    0 |       0 |       0 |         0 |          0 |               1 |               0 |               0 |                0 |                1 |
# >> |----+---------+-----------+---------+-------------------------------------------+----------------+------------------+---------+---------------+--------------------+---------------+-------------------------+---------------------------+---------------------------+---------------------+----------------------+---------+---------+-----------+------------+-----------------+-----------------+-----------------+------------------+------------------|
# >> |-----------------+-------+--------|
# >> | model           | count | 最終ID |
# >> |-----------------+-------+--------|
# >> | Colosseum::User |    13 |     77 |
# >> | Actb::Question  |     3 |     15 |
# >> | Actb::Room      |     1 |      3 |
# >> | Actb::Season    |    11 |     58 |
# >> | Actb::Profile   |    13 |     77 |
# >> | Actb::GoodMark  |     1 |      3 |
# >> | Actb::BadMark   |     1 |      3 |
# >> | Actb::ClipMark  |     1 |      3 |
# >> | Actb::Folder    |    39 |    231 |
# >> | Actb::Kind      |     2 |     16 |
# >> |-----------------+-------+--------|
