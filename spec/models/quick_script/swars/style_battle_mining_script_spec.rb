require "rails_helper"

RSpec.describe QuickScript::Swars::StyleBattleMiningScript, type: :model do
  it "works" do
    user1 = Swars::User.create!
    user2 = Swars::User.create!
    battle = ::Swars::Battle.create_with_members!([user1, user2])
    ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
    scope = Swars::Membership.where(id: ids)
    QuickScript::Swars::StyleBattleMiningScript.new({}, { scope: scope, need_size: 1 }).cache_write
    tp QuickScript::Swars::StyleBattleMiningScript.new.aggregate if $0 == __FILE__
    assert { QuickScript::Swars::StyleBattleMiningScript.new.aggregate[:"王道"] == [battle.id] }
  end
end
# >> Run options: exclude {ai_active: true, login_spec: true, slow_spec: true}
# >>
# >> QuickScript::Swars::StyleBattleMiningScript
# >> 1999-12-31T15:00:00.000Z pid=77627 tid=1lvn INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >> |--------+-----|
# >> |   変態 | []  |
# >> |   王道 | [1] |
# >> | 準変態 | []  |
# >> | 準王道 | [1] |
# >> |--------+-----|
# >>   works (FAILED - 1)
# >>
# >> Failures:
# >>
# >>   1) QuickScript::Swars::StyleBattleMiningScript works
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:12:in 'block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:27:in 'block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:27:in 'block (2 levels) in <main>'
# >>
# >> Top 1 slowest examples (0.51544 seconds, 18.3% of total time):
# >>   QuickScript::Swars::StyleBattleMiningScript works
# >>     0.51544 seconds -:4
# >>
# >> Finished in 2.81 seconds (files took 1.47 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Failed examples:
# >>
# >> rspec -:4 # QuickScript::Swars::StyleBattleMiningScript works
# >>
