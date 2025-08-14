require "rails_helper"

RSpec.describe Ppl::Membership, type: :model do
  it "works" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { name: "alice", result_key: "維持", age: 1, win: 3 })
    membership = Ppl::User["alice"].memberships.sole
    assert { membership.result_info.name == "維持" }
  end
end
