require "./setup"

user1 = Swars::User.create!
user2 = Swars::User.create!
@battles = []
@battles << Swars::Battle.create!(strike_plan: "糸谷流右玉") do |e|
  e.memberships.build(user: user1, grade_key: grade_key1)
  e.memberships.build(user: user2, grade_key: grade_key2)
end
scope = Swars::Membership.where(id: @battles.flat_map(&:membership_ids))
object = QuickScript::Swars::GradeSegmentScript.new({}, batch_limit: 1, scope: scope)
object.cache_write
object.call
