require "./setup"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1787.18 ms"
# _ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "1585.18 ms"

_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "448.79 ms"
_ { Swars::User["HIKOUKI_GUMO"].stat(sample_max: 200).to_hash } # => "245.34 ms"
1585.18 / 244.29                                                # => 6.488927094846289
