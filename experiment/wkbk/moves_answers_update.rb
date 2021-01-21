require "./setup"

# Wkbk::Question.destroy_all
# user1 = User.create!
# question1 = user1.wkbk_questions.create_mock1
# tp question1.moves_answers
# exit

question1 = Wkbk::Question.first
question1.reload
question1.reload

tp question1.save!

Wkbk::Question.find_each do |e|
  e.moves_answers.each do |e|
    e.send(:attribute_will_change!, :moves_str)
    e.save!(touch: false)
  end
end

tp question1.moves_answers
# ~> -:12:in `<main>': undefined method `reload' for nil:NilClass (NoMethodError)
