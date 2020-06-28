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
    e.title                 = "(title#{i})"
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
question.folder # => #<Actb::TrashBox id: 234, user_id: 78, type: "Actb::TrashBox", created_at: "2020-06-28 02:00:20", updated_at: "2020-06-28 02:00:20">

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
battle                          # => #<Actb::Battle id: 1, room_id: 1, parent_id: nil, rule_id: 22, final_id: 5, begin_at: "2020-06-28 02:00:23", end_at: nil, battle_pos: 0, created_at: "2020-06-28 02:00:23", updated_at: "2020-06-28 02:00:23">

battle.users.count                # => 2
battle.battle_pos               # => 0

battle2 = battle.onaji_heya_wo_atarasiku_tukuruyo # => #<Actb::Battle id: 2, room_id: 1, parent_id: 1, rule_id: 22, final_id: 5, begin_at: "2020-06-28 02:00:23", end_at: nil, battle_pos: 1, created_at: "2020-06-28 02:00:23", updated_at: "2020-06-28 02:00:23">
battle2.battle_pos                            # => 1

membership = battle.memberships.first

# 出題
battle.best_questions             # => [{"id"=>142, "init_sfen"=>"position sfen 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"斜めに弱い", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*2c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>143, "init_sfen"=>"position sfen 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"桂馬をうまく使う", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"N*2c 1a2a G*3a", "end_sfen"=>nil}, {"moves_count"=>3, "moves_str"=>"N*2c 2b2c G*1b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>144, "init_sfen"=>"position sfen ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"棺桶美濃あるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b7c", "end_sfen"=>nil}, {"moves_count"=>7, "moves_str"=>"S*7a 8b7a G*6b 7a8b 6b7b 8b9b 7b8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>145, "init_sfen"=>"position sfen ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"美濃囲いあるある", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"B*7a 8b9b P*9c 8a9c G*8b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>146, "init_sfen"=>"position sfen ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"成っちゃだめ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*9c 8a9c 8b8a", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>147, "init_sfen"=>"position sfen 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"銀の弱点", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>3, "moves_str"=>"L*2b 3a2b G*3b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>148, "init_sfen"=>"position sfen 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"玉をひっぱり上げる", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b2a G*2b", "end_sfen"=>nil}, {"moves_count"=>5, "moves_str"=>"G*2b 2a2b N*3d 2b1b G*2b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>149, "init_sfen"=>"position sfen 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"はじまりの桂", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*4c", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"N*6c", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>150, "init_sfen"=>"position sfen ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1", "time_limit_sec"=>60, "difficulty_level"=>1, "title"=>"致命傷になる玉の早逃げ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"N*7d", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>151, "init_sfen"=>"position sfen lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1", "time_limit_sec"=>180, "difficulty_level"=>4, "title"=>"むずいよ", "description"=>nil, "hint_desc"=>nil, "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>11, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 6a7b G*6c 7b8b 6b7a 8b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b7a G*7b", "end_sfen"=>nil}, {"moves_count"=>13, "moves_str"=>"N*6d 6c6d B*4a 5b6a S*6b 7a6b G*5b 6a7a 5b6b 7a6b S*6c 6b6a G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>152, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title0)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>153, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title1)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>154, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title2)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>155, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title3)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>156, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title4)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>157, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title5)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>158, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title6)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>159, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title7)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>160, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title8)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>nil, "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}, {"id"=>161, "init_sfen"=>"position sfen 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1", "time_limit_sec"=>180, "difficulty_level"=>5, "title"=>"(title9)", "description"=>"(description)", "hint_desc"=>"(hint_desc)", "other_author"=>"(other_author)", "user"=>{"id"=>78, "key"=>"sysop", "name"=>"運営", "avatar_path"=>"/assets/human/0007_fallback_avatar_icon-a69a1f4bc0d532871c7fe2fd715c3f2fcdbb44f511f0dcfaab01ea087138338b.png"}, "moves_answers"=>[{"moves_count"=>1, "moves_str"=>"G*4b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*5b", "end_sfen"=>nil}, {"moves_count"=>1, "moves_str"=>"G*6b", "end_sfen"=>nil}], "ox_record"=>{"ox_total"=>0, "o_rate"=>0.0}}]

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
  question.messages.create!(user: user1, body: "message") # => #<Actb::QuestionMessage id: 19, user_id: 78, question_id: 139, body: "message", created_at: "2020-06-28 02:00:24", updated_at: "2020-06-28 02:00:24">, #<Actb::QuestionMessage id: 20, user_id: 78, question_id: 139, body: "message", created_at: "2020-06-28 02:00:24", updated_at: "2020-06-28 02:00:24">, #<Actb::QuestionMessage id: 21, user_id: 78, question_id: 139, body: "message", created_at: "2020-06-28 02:00:24", updated_at: "2020-06-28 02:00:24">, #<Actb::QuestionMessage id: 22, user_id: 78, question_id: 139, body: "message", created_at: "2020-06-28 02:00:24", updated_at: "2020-06-28 02:00:24">, #<Actb::QuestionMessage id: 23, user_id: 78, question_id: 139, body: "message", created_at: "2020-06-28 02:00:24", updated_at: "2020-06-28 02:00:24">
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
# >> | 最新シーズン情報ID | 87     |
# >> | 永続的プロフ情報ID | 78     |
# >> |         部屋入室数 | 1      |
# >> |             対局数 | 2      |
# >> |         問題履歴数 | 23     |
# >> |     バトル中発言数 | 0      |
# >> |       ロビー発言数 | 0      |
# >> |     問題コメント数 | 0      |
# >> |         作成問題数 | 23     |
# >> |       問題高評価率 | 0.0    |
# >> |       問題高評価数 | 0      |
# >> |       問題低評価数 | 0      |
# >> |--------------------+--------|
# >> |---------------------+---------------------------|
# >> |                  id | 87                        |
# >> |            judge_id | 29                        |
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
# >> |            skill_id | 148                       |
# >> |         skill_point | 20.0                      |
# >> |     skill_last_diff | 20.0                      |
# >> |          created_at | 2020-06-28 11:00:24 +0900 |
# >> |          updated_at | 2020-06-28 11:00:24 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |             user_id | 78                        |
# >> |           season_id | 38                        |
# >> |        create_count | 2                         |
# >> |          generation | 11                        |
# >> |---------------------+---------------------------|
# >> |---------------------+---------------------------|
# >> |                  id | 78                        |
# >> |             user_id | 78                        |
# >> |            judge_id | 32                        |
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
# >> |            skill_id | 148                       |
# >> |         skill_point | 0.0                       |
# >> |     skill_last_diff | 0.0                       |
# >> |          created_at | 2020-06-28 11:00:20 +0900 |
# >> |          updated_at | 2020-06-28 11:00:20 +0900 |
# >> |    disconnect_count | 0                         |
# >> |     disconnected_at |                           |
# >> |---------------------+---------------------------|
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | id | name       | generation | begin_at                  | end_at                    | created_at                | updated_at                |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> | 28 | シーズン1  |          1 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:20 +0900 | 2020-06-28 11:00:20 +0900 |
# >> | 29 | シーズン2  |          2 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 30 | シーズン3  |          3 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 31 | シーズン4  |          4 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 32 | シーズン5  |          5 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 33 | シーズン6  |          6 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 34 | シーズン7  |          7 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 35 | シーズン8  |          8 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 36 | シーズン9  |          9 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 37 | シーズン10 |         10 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> | 38 | シーズン11 |         11 | 2020-06-01 00:00:00 +0900 | 2020-09-01 00:00:00 +0900 | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |
# >> |----+------------+------------+---------------------------+---------------------------+---------------------------+---------------------------|
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | id  | key                              | user_id | folder_id | lineage_id | init_sfen                                                                | time_limit_sec | difficulty_level | title                  | description   | hint_desc   | other_author   | source_media_name | source_media_url | source_published_on | created_at                | updated_at                | good_rate | moves_answers_count | histories_count | good_marks_count | bad_marks_count | clip_marks_count | messages_count |
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> | 139 | ef5c5009401cf717ae7e37dd8c834a7d |      78 |       234 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l18p 1                               |             60 |                1 | はじまりの金           | いちばん簡単  | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:20 +0900 | 2020-06-28 11:00:23 +0900 |       0.0 |                   1 |               1 |                1 |               0 |                0 |              5 |
# >> | 140 | a022f1d45ccd3460f6da8008843269e4 |      78 |       233 |         52 | ln1gk2nl/6g2/p2pppspp/2p3p2/7P1/1rP6/P2PPPP1P/2G3SR1/LN2KG1NL b BSPbsp 1 |             60 |                1 | 居玉は危険             |               |             |                |                   |                  |                     | 2020-06-28 11:00:20 +0900 | 2020-06-28 11:00:23 +0900 |       0.0 |                   1 |               1 |                0 |               1 |                0 |              0 |
# >> | 141 | fa8fc185045af4d329ff13f9a632f156 |      78 |       232 |         50 | ln1g5/1ks6/pppp5/9/4B4/9/9/9/9 b GN2rb2g3s2n3l14p 1                      |             60 |                1 | 美濃囲いの弱点         |               |             |                |                   |                  |                     | 2020-06-28 11:00:20 +0900 | 2020-06-28 11:00:20 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                1 |              0 |
# >> | 142 | 40085dba3bd506267fd3039dea8ea404 |      78 |       232 |         50 | 7nk/7sp/9/9/4B4/9/9/9/9 b N2rb4g3s2n4l17p 1                              |             60 |                1 | 斜めに弱い             |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 143 | cbd6adcc26c6ae176a04a92450f2cf27 |      78 |       232 |         50 | 8k/7g1/8G/9/9/9/9/9/9 b GN2r2bg4s3n4l18p 1                               |             60 |                1 | 桂馬をうまく使う       |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 144 | 57f055d2775e96b4c1e7e879623993b3 |      78 |       232 |         51 | ln7/1ks4R1/pppp5/9/9/9/9/9/9 b GSr2b3g2s3n3l14p 1                        |             60 |                1 | 棺桶美濃あるある       |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 145 | 84fea0e5c3fba625431e319ac6d7c4f1 |      78 |       232 |         51 | ln7/1ksG5/1pp6/p8/9/9/9/9/9 b BGP2rb2g3s3n3l14p 1                        |             60 |                1 | 美濃囲いあるある       |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 146 | 0dcbb33d060d3507dc29f46f23f82643 |      78 |       232 |         50 | ln7/kSG6/1p7/p8/9/9/9/9/9 b L2r2b3g3s3n2l16p 1                           |             60 |                1 | 成っちゃだめ           |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 147 | b0538a0efd2a8ee173d6fd11160fcf4f |      78 |       232 |         50 | 6skl/9/7G1/9/9/9/9/9/9 b GL2r2b2g2s4n2l18p 1                             |             60 |                1 | 銀の弱点               |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 148 | cba9132a42f676ae206d3017b848b764 |      78 |       232 |         50 | 6rkl/6s2/5pnpp/9/9/9/9/9/9 b 2GNr2b2g3s2n2l15p 1                         |             60 |                1 | 玉をひっぱり上げる     |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 149 | e1dbd0d616511f4a16016595f21f662f |      78 |       232 |         50 | 3gkg3/9/4+B4/9/9/9/9/9/9 b N2rbg4s3n4l18p 1                              |             60 |                1 | はじまりの桂           |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   2 |               1 |                0 |               0 |                0 |              0 |
# >> | 150 | ed76b107012f82dfa4270c673aa18e5b |      78 |       232 |         50 | ln1g5/1rsk5/p2pp4/9/1p7/9/9/9/9 b Nr2b3g3s2n3l14p 1                      |             60 |                1 | 致命傷になる玉の早逃げ |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   1 |               1 |                0 |               0 |                0 |              0 |
# >> | 151 | c4dc5ed464b323fc75d0d872171514ee |      78 |       232 |         50 | lns3+P2/4k4/ppppp1p2/9/5P3/9/9/9/9 b B2GSN2rb2g2s2n3l10p 1               |            180 |                4 | むずいよ               |               |             |                |                   |                  |                     | 2020-06-28 11:00:21 +0900 | 2020-06-28 11:00:21 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 152 | d506614288f000bd820c7301eff0328c |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1                                |            180 |                5 | (title0)               | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:22 +0900 | 2020-06-27 11:00:22 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 153 | c2d13d5176cd13bcaca1a6e182a341c5 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1                                |            180 |                5 | (title1)               | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-28 11:00:22 +0900 | 2020-06-27 12:00:22 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 154 | b51a1071b009c0ae1bf89aba8ac5a3bb |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l3p 1                                |            180 |                5 | (title2)               | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:22 +0900 | 2020-06-27 13:00:22 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 155 | abfac0498f41d8fc6962e4918cfc9e92 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l4p 1                                |            180 |                5 | (title3)               | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 14:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 156 | 5c1142885fd5da08538900266cb606ad |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l5p 1                                |            180 |                5 | (title4)               | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 15:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 157 | 129170f79a86ab1147897d72b1b41056 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l6p 1                                |            180 |                5 | (title5)               | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 16:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 158 | 69c73eef9e15ec47a00665a760477427 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l7p 1                                |            180 |                5 | (title6)               | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 17:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 159 | 1ddf799fb3afe682c00ebc9debd8f0e1 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l8p 1                                |            180 |                5 | (title7)               | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 18:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 160 | 2ea44d8d1c1c7614dd6ea5dc9a184dba |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l9p 1                                |            180 |                5 | (title8)               | (description) | (hint_desc) |                |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 19:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> | 161 | 3f94b90f050cae7b71907f7902e4e7e8 |      78 |       232 |         50 | 4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l10p 1                               |            180 |                5 | (title9)               | (description) | (hint_desc) | (other_author) |                   |                  |                     | 2020-06-28 11:00:23 +0900 | 2020-06-27 20:00:23 +0900 |       0.0 |                   3 |               1 |                0 |               0 |                0 |              0 |
# >> |-----+----------------------------------+---------+-----------+------------+--------------------------------------------------------------------------+----------------+------------------+------------------------+---------------+-------------+----------------+-------------------+------------------+---------------------+---------------------------+---------------------------+-----------+---------------------+-----------------+------------------+-----------------+------------------+----------------|
# >> |------------------------+-------+--------|
# >> | model                  | count | 最終ID |
# >> |------------------------+-------+--------|
# >> | User                   |     9 |     86 |
# >> | Actb::Question         |    23 |    161 |
# >> | Actb::QuestionMessage  |     5 |     23 |
# >> | Actb::Room             |     1 |      1 |
# >> | Actb::RoomMembership   |     2 |      2 |
# >> | Actb::RoomMessage      |     0 |        |
# >> | Actb::Battle           |     2 |      2 |
# >> | Actb::BattleMembership |     4 |      4 |
# >> | Actb::Season           |    11 |     38 |
# >> | Actb::SeasonXrecord    |    10 |     87 |
# >> | Actb::MainXrecord      |     9 |     86 |
# >> | Actb::Setting          |     9 |     86 |
# >> | Actb::GoodMark         |     1 |      1 |
# >> | Actb::BadMark          |     1 |      1 |
# >> | Actb::ClipMark         |     1 |      1 |
# >> | Actb::Folder           |    27 |    258 |
# >> | Actb::Lineage          |     7 |     56 |
# >> | Actb::Judge            |     4 |     32 |
# >> | Actb::Rule             |     3 |     24 |
# >> | Actb::Skill            |    21 |    168 |
# >> | Actb::LobbyMessage     |     0 |        |
# >> |------------------------+-------+--------|
