require "./setup"
Talk::YomiageNormalizer.normalize("http://www.example.com/?a=1") # => "example com"
Talk::YomiageNormalizer.normalize("w")                           # => "わら"
