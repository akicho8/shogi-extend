require "#{__dir__}/setup"
rows = Ppl::Spider.new(season_number: 66, take_size: 1, verbose: false, sleep: 0).call # => [{result_key: "維", start_pos: 1, name: "古賀悠聖", _mentor: "中田功", age: 18, win: 6, lose: 12, ox: "oxxoxxxoxxxxooxxxo"}]
attrs = rows.sole               # => {result_key: "維", start_pos: 1, name: "古賀悠聖", _mentor: "中田功", age: 18, win: 6, lose: 12, ox: "oxxoxxxoxxxxooxxxo"}tp attrs
attrs[:result_key] # => "維"
attrs[:start_pos]  # => 1
attrs[:name]       # => "古賀悠聖"
attrs[:age]        # => 18
attrs[:lose]       # => 12
attrs[:ox]         # => "oxxoxxxoxxxxooxxxo"
# >> |------------+--------------------|
# >> | result_key | 維                 |
# >> |  start_pos | 1                  |
# >> |       name | 古賀悠聖           |
# >> |    _mentor | 中田功             |
# >> |        age | 18                 |
# >> |        win | 6                  |
# >> |       lose | 12                 |
# >> |         ox | oxxoxxxoxxxxooxxxo |
# >> |------------+--------------------|
