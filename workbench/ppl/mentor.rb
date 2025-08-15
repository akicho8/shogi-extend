require "#{__dir__}/setup"
# Ppl.setup_for_workbench
# Ppl::Updater.update_raw(5, { mentor: "親", name: "子", result_key: "維持", })
# Ppl::Mentor["親"].users_count   # => 1

Ppl::Mentor["剣持"].users_count   # => 0
Ppl::Mentor["剣持"].users         # => #<ActiveRecord::Associations::CollectionProxy []>
