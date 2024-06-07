require "rails_helper"

module Swars
  RSpec.describe User::Stat::VsStat, type: :model, swars_spec: true do
    describe "段級" do
      def case1(white, judge_key)
        Battle.create! do |e|
          e.memberships.build(user: @user, judge_key: judge_key)
          e.memberships.build(grade: Grade.find_by(key: white))
        end
      end

      it "works" do
        @user = User.create!

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
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> User::Stat::VsStat
# >>   段級
# >>     works (FAILED - 1)
# >>
# >> Failures:
# >>
# >>   1) User::Stat::VsStat 段級 works
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:29:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Top 1 slowest examples (0.7772 seconds, 27.1% of total time):
# >>   User::Stat::VsStat 段級 works
# >>     0.7772 seconds -:24
# >>
# >> Finished in 2.86 seconds (files took 1.57 seconds to load)
# >> 1 example, 1 failure
# >>
# >> Failed examples:
# >>
# >> rspec -:24 # User::Stat::VsStat 段級 works
# >>
