require "./setup"

Colosseum::User.delete_all

Actb.destroy_all
Actb.setup

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

# 最初の問題だけゴミ箱へ
question = Actb::Question.first!
# question.update!(folder: question.user.actb_trash_box) の方法はださい
question.user.actb_trash_box.questions << question
question.folder # => #<Actb::TrashBox id: 825, user_id: 275, type: "Actb::TrashBox", created_at: "2020-05-19 10:10:16", updated_at: "2020-05-19 10:10:16">

question = Actb::Question.second!
question.display_key2           # => "active"
question.display_key2 = :draft
question.save!                 # => 
question.folder                # => 
tp question.as_json
exit

# 部屋を立てる
room = Actb::Room.create! do |e|
  e.memberships.build(user: user1)
  e.memberships.build(user: user2)
end
membership = room.memberships.first

# 出題
room.best_questions             # => 

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
# ~> /usr/local/var/rbenv/versions/2.6.5/lib/ruby/gems/2.6.0/gems/activemodel-6.0.2.2/lib/active_model/attribute_methods.rb:431:in `method_missing': undefined local variable or method `question' for #<Actb::Question:0x00007ff5dc8f8958> (NameError)
# ~> 	from /Users/ikeda/src/shogi_web/app/models/actb/question.rb:180:in `display_key2='
# ~> 	from -:51:in `<main>'
