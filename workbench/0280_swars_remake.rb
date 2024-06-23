require "./setup"
p Swars::User["bsplive"].battles.each_record { |e| p e }
