require "rails_helper"

RSpec.describe Actb::Judge, type: :model do
  include ActbSupportMethods

  let(:model)  { Actb::Judge       }
  let(:record) { Actb::Judge.first }

  it "model" do
    assert { model.fetch(:win).key  == "win" }
    assert { model.fetch("win").key == "win" }
    assert { model.lookup(:win).key == "win" }
    assert { model.lookup(nil)      == nil }
  end

  it "record" do
    assert { record.name           == "勝ち" }
    assert { record.pure_info.name == "勝ち" }
  end
end
