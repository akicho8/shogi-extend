require "./setup"

black = Swars::User.create!
Swars::Battle.create!(strike_plan: "糸谷流右玉") do |e|
  e.memberships.build(user: black)
end
black.stat.right_king_stat.to_names_chart # => [{name: :右玉, value: 1}, {name: :糸谷流右玉, value: 1}]
black.stat.right_king_stat.to_ratio_chart # => [{name: "右玉", value: 2}, {name: "その他", value: -1}]
