require "./setup"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "601.95 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "384.90 ms"
