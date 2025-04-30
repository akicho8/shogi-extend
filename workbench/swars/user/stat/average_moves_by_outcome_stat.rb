require "./setup"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "91.90 ms"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "20.36 ms"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "14.28 ms"
