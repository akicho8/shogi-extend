require "./setup"
require "pp"

User.delete_all
Xclock.destroy_all
Xclock.setup

# user1 = User.sysop
# 
# question = user1.xclock_questions.create! do |e|
#   e.init_sfen = "4k4/9/4G4/9/9/9/9/9/9 b G2r2b2g4s4n4l1p 1"
#   e.moves_answers.build(moves_str: "G*4b")
#   e.moves_answers.build(moves_str: "G*5b")
#   e.moves_answers.build(moves_str: "G*6b")
#   e.time_limit_sec    = 60 * 3
#   e.difficulty_level  = 5
#   e.title             = "(title)"
#   e.description       = "(description)"
#   e.hint_desc         = "(hint_desc)"
#   e.source_author      = "(source_author)"
# end
# 
# Xclock::Question.export_all
# 
# User.delete_all
# Xclock.destroy_all
# Xclock.setup

Xclock::Question.export_all
Xclock::Question.import_all
# >> load: /Users/ikeda/src/shogi_web/app/models/xclock/questions.yml
# >> write: /Users/ikeda/src/shogi_web/app/models/xclock/questions.yml
# >> load: /Users/ikeda/src/shogi_web/app/models/xclock/questions.yml
