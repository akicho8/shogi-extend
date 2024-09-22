require "./setup"
Talk::YomiageNormalizer.new("http://www.example.com/?a=1").to_s # => "example com"
Talk::YomiageNormalizer.new("w").to_s                           # => "わら"
