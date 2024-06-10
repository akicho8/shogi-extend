require "./setup"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "145.21 ms"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "20.98 ms"
_ { Swars::User["SugarHuuko"].stat.average_moves_by_outcome_stat.to_chart }  # => "17.40 ms"
