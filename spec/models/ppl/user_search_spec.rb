require "rails_helper"

RSpec.describe Ppl::UserSearch, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { name: "alice", })
    Ppl::Updater.update_raw(6, { name: "bob",   })
    Ppl::Updater.update_raw(7, { name: "carol", })
    assert { Ppl::User.search(name_rel: "a").collect(&:name)       == ["alice", "bob", "carol"] }
    assert { Ppl::User.search(season_number_rel: "6").collect(&:name) == ["bob"] }
    assert { Ppl::User.search(query: "a").collect(&:name)          == ["alice", "carol"] }
  end
end
