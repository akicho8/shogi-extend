require "rails_helper"

RSpec.describe Ppl::UserSearch, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ mentor: "X", name: "alice", })
    Ppl::SeasonKeyVo["6"].update_by_records({ mentor: "Y", name: "bob",   })
    Ppl::SeasonKeyVo["7"].update_by_records({ mentor: "Z", name: "carol", })
    assert { Ppl::User.search(name: "a").collect(&:name).sort              == ["alice", "bob", "carol"] }
    assert { Ppl::User.search(season_key: "6").collect(&:name).sort == ["bob"]                   }
    assert { Ppl::User.search(mentor_name: "X").collect(&:name).sort       == ["alice"]                 }
    assert { Ppl::User.search(query: "a").collect(&:name).sort             == ["alice", "carol"]        }
  end

  it "[BUGFIX] Mentor を join しているとき name カラムの所有テーブルがはっきりしなくなる" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ mentor: "X", name: "alice", })
    assert { Ppl::User.search(mentor_name: "X", query: "a").collect(&:name) == ["alice"] }
  end
end
