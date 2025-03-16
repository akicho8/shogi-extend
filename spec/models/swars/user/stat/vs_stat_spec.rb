require "rails_helper"

RSpec.describe Swars::User::Stat::VsStat, type: :model, swars_spec: true do
  describe "段級" do
    def case1(white, judge_key)
      Swars::Battle.create! do |e|
        e.memberships.build(user: @user, judge_key: judge_key)
        e.memberships.build(grade: Swars::Grade.find_by(key: white))
      end
    end

    it "works" do
      @user = Swars::User.create!

      case1("初段", :win)
      case1("九段", :win)
      case1("九段", :win)
      case1("九段", :lose)

      outcome = [
        {:grade_name => "九段", :judge_counts => {:win => 2, :lose => 1}, :appear_ratio => 0.75},
        {:grade_name => "初段", :judge_counts => {:win => 1,           }, :appear_ratio => 0.25},
      ]
      assert { @user.stat.vs_stat.to_chart == outcome }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::User::Stat::VsStat
# >>   段級
# >>     works (FAILED - 1)
# >>
# >> Swars::Failures:
# >>
# >>   1) Swars::User::Stat::VsStat 段級 works
# >>      Swars::Failure/Error: Swars::Unable to find - to read failed line
# >>      Swars::Minitest::Assertion:
# >>      # -:29:in `block (3 levels) in <# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Swars::Top 1 slowest examples (0.7772 seconds, 27.1% of total time):
# >>   Swars::User::Stat::VsStat 段級 works
# >>     0.7772 seconds -:24
# >>
# >> Swars::Finished in 2.86 seconds (files took 1.57 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Swars::Failed examples:
# >>
# >> rspec -:24 # Swars::User::Stat::VsStat 段級 works
# >>
