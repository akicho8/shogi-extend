require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw("5", { mentor: "X", name: "alice", })
Ppl::Updater.update_raw("6", { mentor: "Y", name: "bob",   })
Ppl::Updater.update_raw("7", { mentor: "Z", name: "carol", })
Ppl::User.search(name: "a").collect(&:name).sort              # => ["alice", "bob", "carol"]
Ppl::User.search(season_key: "6").collect(&:name).sort # => ["bob"]
Ppl::User.search(mentor_name: "X").collect(&:name).sort       # => ["alice"]
Ppl::User.search(query: "a").collect(&:name).sort             # => ["alice", "carol"]
