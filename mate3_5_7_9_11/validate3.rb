require File.expand_path("../../config/environment", __FILE__)

tp Pathname(".").glob("*.txt").collect { |e|
  { file: e, count: e.readlines.count }
}
# >> |------------+--------|
# >> | file       | count  |
# >> |------------+--------|
# >> | mate3.txt  | 998405 |
# >> | mate7.txt  | 999071 |
# >> | mate5.txt  | 998827 |
# >> | mate9.txt  | 999673 |
# >> | mate11.txt | 999998 |
# >> |------------+--------|
