require "./setup"

Actb::Question.destroy_all

user = User.sysop

params = {
  question: {
    "init_sfen" => "4k4/9/4GG3/9/9/9/9/9/9 b 2r2b2g4s4n4l18p 1",
    "moves_answers"=>[{"moves_str"=>"4c5b"}],
    "time_limit_clock"=>"1999-12-31T15:03:00.000Z",
  },
}.deep_symbolize_keys

question = user.actb_questions.build
question.together_with_params_came_from_js_update(params)
question.moves_answers.collect{|e|e.moves_str} # => ["4c5b"]

question = user.actb_questions.build
begin
# ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
question.together_with_params_came_from_js_update(params)
# ActiveRecord::Base.logger = nil
rescue
end
question.persisted?             # => false

