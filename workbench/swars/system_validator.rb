require "./setup"
# Swars::SystemValidator.new.call

Swars::User["abacus10"].memberships.each do |e|
  p e
  e.battle.rebuild
end
