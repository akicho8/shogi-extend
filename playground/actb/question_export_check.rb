require "./setup"
require "pp"

User.delete_all
Actb.destroy_all
Actb.setup

# user1 = User.sysop
# 
# question = user1.actb_questions.create! do |e|
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
# Actb::Question.export_all
# 
# User.delete_all
# Actb.destroy_all
# Actb.setup

Actb::Question.export_all
Actb::Question.import_all
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
# >> write: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
