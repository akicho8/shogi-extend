require "rails_helper"

RSpec.describe TransientAggregate, type: :model, swars_spec: true do
  it "works" do
    TransientAggregate["A"].set
    TransientAggregate["B"].set
    TransientAggregate["C"].set
    TransientAggregate["B"].destroy_all
    assert { TransientAggregate.group(:group_name).count == { "A" => 1, "C" => 1 } }

    # black = User.create!
    # Battle.create!(csa_seq: KifuGenerator.generate_n(14)) do |e|
    #   e.memberships.build(user: black)
    # end
    # TransientAggregate.destroy_all
    # TransientAggregate.set(scope: black.memberships)
    # assert { TransientAggregate.aggregated_value.present? }
    # assert { TransientAggregate.latest_generation == 0 }
  end
end
