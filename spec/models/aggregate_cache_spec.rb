require "rails_helper"

RSpec.describe AggregateCache, type: :model, swars_spec: true do
  it "works" do
    assert { AggregateCache.group(:group_name).count == {} }
    AggregateCache["A"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }
    AggregateCache["A"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }
    AggregateCache["B"].write
    AggregateCache["B"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1, "B" => 1 } }
  end
end
