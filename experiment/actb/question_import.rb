require "./setup"

# Actb::Question.exists?                 # => true
# Actb::Question.destroy_all

Actb::Question.import_all
Actb::Question.count            # => 10
# >> load: /Users/ikeda/src/shogi_web/app/models/actb/questions.yml
