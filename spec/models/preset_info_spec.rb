require "rails_helper"

RSpec.describe PresetInfo, type: :model do
  it "works" do
    assert { PresetInfo.lookup("平手").db_record! }
  end
end
