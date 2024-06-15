require "./setup"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "533.03 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "312.74 ms"
