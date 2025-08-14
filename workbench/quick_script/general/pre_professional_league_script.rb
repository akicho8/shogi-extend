require "#{__dir__}/setup"
e = QuickScript::General::PreProfessionalLeagueScript.new(name_rel: "藤井聡太")
e.target_users                # => #<ActiveRecord::Relation []>
tp e.current_scope
