require "#{__dir__}/setup"

Swars::GradeInfo["一五級"].name # => "15級"
Swars::GradeInfo["十五級"].name # => "15級"
Swars::GradeInfo["十級"].name   # => "10級"
Swars::GradeInfo["一級"].name   # => "1級"
Swars::GradeInfo["一段"].name   # => "初段"
Swars::GradeInfo["1段"].name    # => "初段"
Swars::GradeInfo["2段"].name    # => "二段"
Swars::GradeInfo["10段"].name   # => "十段"
Swars::GradeInfo["１０段"].name # => "十段"

Swars::GradeInfo["1"]           # => nil
Swars::GradeInfo["123_456"]     # => nil
