require "rails_helper"

RSpec.describe Ppl::UserSearch, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].users_update({ mentor: "X", name: "alice", })
    Ppl::SeasonKeyVo["6"].users_update({ mentor: "Y", name: "bob",   })
    Ppl::SeasonKeyVo["7"].users_update({ mentor: "Z", name: "carol", })
    assert { Ppl::User.search(user_name: "carol").collect(&:name).sort == ["carol"]          }
    assert { Ppl::User.search(season_key: "6").collect(&:name).sort    == ["bob"]            }
    assert { Ppl::User.search(mentor_name: "X").collect(&:name).sort   == ["alice"]          }
    assert { Ppl::User.search(query: "a").collect(&:name).sort         == ["alice", "carol"] }
  end

  it "[BUGFIX] Mentor を join しているとき name カラムの所有テーブルがはっきりしなくなる" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].users_update({ mentor: "X", name: "alice", })
    assert { Ppl::User.search(mentor_name: "X", query: "a").collect(&:name) == ["alice"] }
  end
end
