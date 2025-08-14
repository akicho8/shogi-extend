require "#{__dir__}/setup"
Ppl.setup_for_workbench
Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持" })
Ppl::Updater.update_raw(6, { name: "bob",   result_key: "維持" })
Ppl::Updater.update_raw(7, { name: "carol",   result_key: "維持" })
Ppl::User.search(name_rel: "a").collect(&:name)       # => ["alice", "bob", "carol"]
Ppl::User.search(season_number_rel: "6").collect(&:name) # => ["bob"]
Ppl::User.search(query: "a").collect(&:name)          # => ["alice", "carol"]
