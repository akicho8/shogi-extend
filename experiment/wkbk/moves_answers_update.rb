require "./setup"

# Wkbk::Article.destroy_all
# user1 = User.create!
# article1 = user1.wkbk_articles.create_mock1
# tp article1.moves_answers
# exit

article1 = Wkbk::Article.first
article1.reload
article1.reload

tp article1.save!

Wkbk::Article.find_each do |e|
  e.moves_answers.each do |e|
    e.send(:attribute_will_change!, :moves_str)
    e.save!(touch: false)
  end
end

tp article1.moves_answers
# ~> -:12:in `<main>': undefined method `reload' for nil:NilClass (NoMethodError)
