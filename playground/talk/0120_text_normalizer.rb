require "./setup"
Talk::TextNormalizer.new("http://www.example.com/?a=1").to_s # => "example com"
Talk::TextNormalizer.new("w").to_s                           # => "わら"
