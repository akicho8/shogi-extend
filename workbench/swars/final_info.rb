require "./setup"
Swars::FinalInfo.fetch("通信不調").name  # => "切断"
Swars::FinalInfo.fetch(:"通信不調").name # => "切断"
