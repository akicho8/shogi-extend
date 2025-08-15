require "rails_helper"

RSpec.describe Ppl::Mentor, type: :model do
  it "counter_cache" do
    Ppl.setup_for_workbench
    Ppl::Updater.update_raw(5, { mentor: "親", name: "子", result_key: "維持", })
    assert { Ppl::Mentor["親"].users_count == 1 }
  end
end
