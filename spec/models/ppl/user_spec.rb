require "rails_helper"

RSpec.describe Ppl::User, type: :model do
  it "plus_minus_search" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ name: "XA", })
    Ppl::SeasonKeyVo["6"].update_by_records({ name: "BX", })
    assert { Ppl::User.plus_minus_search("A -B").collect(&:name) == ["XA"] }
  end

  it "works" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["5"].update_by_records({ name: "alice", result_key: "維持", age: 1, win: 3 })
    Ppl::SeasonKeyVo["6"].update_by_records({ name: "alice", result_key: "次点", age: 2, win: 2 })
    Ppl::SeasonKeyVo["7"].update_by_records({ name: "alice", result_key: "昇段", age: 3, win: 1 })
    user = Ppl::User["alice"]
    assert { user.age_min                                == 1   }
    assert { user.age_max                                == 3   }
    assert { user.runner_up_count                        == 1   }
    assert { user.win_max                                == 3   }
    assert { user.promotion_membership.season.key == "7" }
    assert { user.promotion_season_position       == 2   }
    assert { user.promotion_win                          == 1   }
    assert { user.memberships_first.season.key    == "5" }
    assert { user.memberships_last.season.key     == "7" }
  end

  it "退会したと思われる" do
    Ppl.setup_for_workbench
    Ppl::SeasonKeyVo["1"].update_by_records({ name: "alice", result_key: "維持" }) # 1期では alice は
    assert { Ppl::User["alice"].deactivated_membership == nil }         # 現役だが
    Ppl::SeasonKeyVo["2"].update_by_records({ name: "bob",   result_key: "維持" }) # 2期では alice は、いないので
    assert { Ppl::User["alice"].deactivated_membership }                # 退会の情報が入っている
  end
end
