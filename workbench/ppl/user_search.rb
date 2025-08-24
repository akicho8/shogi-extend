require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].update_by_records({ mentor: "X", name: "alice", })
Ppl::SeasonKeyVo["6"].update_by_records({ mentor: "Y", name: "bob",   })
Ppl::SeasonKeyVo["7"].update_by_records({ mentor: "Z", name: "carol", })
Ppl::User.search(name: "a").collect(&:name).sort              # => ["alice", "bob", "carol"]
Ppl::User.search(season_key: "6").collect(&:name).sort # => ["bob"]
Ppl::User.search(mentor_name: "X").collect(&:name).sort       # => ["alice"]
Ppl::User.search(query: "a").collect(&:name).sort             # => ["alice", "carol"]
