require "./setup"

tp Wkbk::ClipMark
# Wkbk::Article.destroy_all

# user = User.sysop
# 
# article1 = user.wkbk_articles.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# article2 = user.wkbk_articles.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l2p 1"
#   e.moves_answers.build(moves_str: "G*5b")
# end
# 
# user.wkbk_clip_marks.create!(article: article1) # => #<Wkbk::ClipMark id: 32, user_id: 9, article_id: 47, created_at: "2020-06-24 11:24:33", updated_at: "2020-06-24 11:24:33">
# user.wkbk_clip_marks.create!(article: article2) # =>
# 
# user.wkbk_clip_marks.count      # =>

