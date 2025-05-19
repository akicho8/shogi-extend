require "rails_helper"

RSpec.describe QuickScript::Swars::GradeSegmentScript, type: :model do
  it "works" do
    def entry(user1, user2, grade_key1, grade_key2)
      @battles << Swars::Battle.create!(strike_plan: "糸谷流右玉") do |e|
        e.memberships.build(user: user1, grade_key: grade_key1)
        e.memberships.build(user: user2, grade_key: grade_key2)
      end
    end

    def aggregate
      @battles = []
      yield
      scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
      object = QuickScript::Swars::GradeSegmentScript.new({}, batch_limit: 1, scope: scope)
      object.cache_write
      object.call
    end

    user1 = Swars::User.create!
    user2 = Swars::User.create!

    rows = aggregate do
      entry(user1, user2, "二段", "四段")
      entry(user1, user2, "二段", "四段")
    end

    assert { rows.pluck(:"投了") == [1.0, 0.0] }
    assert { rows.pluck(:"棋力") == ["四段", "二段"] }
    assert { rows.pluck(:"手数") == [131.0, 131.0] }
  end
end
