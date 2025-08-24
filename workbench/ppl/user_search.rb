require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::SeasonKeyVo["5"].users_update({ mentor: "X", name: "alice", })
Ppl::SeasonKeyVo["6"].users_update({ mentor: "Y", name: "bob",   })
Ppl::SeasonKeyVo["7"].users_update({ mentor: "Z", name: "carol", })
Ppl::User.search(user_name: "carol").collect(&:name).sort # => ["carol"]
Ppl::User.search(season_key: "6").collect(&:name).sort    # => ["bob"]
Ppl::User.search(mentor_name: "X").collect(&:name).sort   # => ["alice"]
Ppl::User.search(query: "a").collect(&:name).sort         # => ["alice", "carol"]
