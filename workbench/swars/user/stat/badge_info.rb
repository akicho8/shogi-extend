require "./setup"
s = SecureRandom.hex * 10000 + "abc"
_ { s.include?("abc") }      # => "0.49 ms"
_ { s.match(/abc/)    }      # => "0.36 ms"
