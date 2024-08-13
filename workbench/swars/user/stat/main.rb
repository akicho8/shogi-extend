require "./setup"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "858.85 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "342.24 ms"

