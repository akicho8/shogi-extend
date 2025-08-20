require "rails_helper"

RSpec.describe Ppl::UserSearch, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { mentor: "X", name: "alice", })
    Ppl::Updater.update_raw(6, { mentor: "Y", name: "bob",   })
    Ppl::Updater.update_raw(7, { mentor: "Z", name: "carol", })
    assert { Ppl::User.search(name: "a").collect(&:name).sort          == ["alice", "bob", "carol"] }
    assert { Ppl::User.search(season_number: "6").collect(&:name).sort == ["bob"]                   }
    assert { Ppl::User.search(mentor_name: "X").collect(&:name).sort   == ["alice"]                 }
    assert { Ppl::User.search(query: "a").collect(&:name).sort         == ["alice", "carol"]        }
  end

  it "[BUGFIX] Mentor を join しているとき name カラムの所有テーブルがはっきりしなくなる" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { mentor: "X", name: "alice", })
    assert { Ppl::User.search(mentor_name: "X", query: "a").collect(&:name) == ["alice"] }
  end
end
