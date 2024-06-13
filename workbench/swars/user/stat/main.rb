require "./setup"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "410.55 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "141.10 ms"
