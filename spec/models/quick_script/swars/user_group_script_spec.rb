require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe UserGroupScript, type: :model do
      def case1
        ::Swars::User.create!(key: "a")
        ::Swars::User.create!(key: "b")
        ::Swars::User.create!(key: "c")
      end

      def inside_options
        {_method: "post", current_user: User.create!}
      end

      def user_items_text
        ["(xname) a", "(xname) b"].join("\n")
      end

      it "通常の出力" do
        case1
        response = UserGroupScript.new({user_items_text: user_items_text}, inside_options).call
        assert { response[:_v_bind][:value][:rows].size == 2 }
      end

      it "Google スプレッドシートに出力" do
        case1
        Timecop.return do
          assert { UserGroupScript.new({user_items_text: user_items_text, google_sheet: "true"}, inside_options).as_json[:redirect_to] }
          GoogleApi::ExpirationTracker.destroy_all
        end
      end

      it "順番" do
        ::Swars::User.create!(key: "alice")
        def case1(order_by)
          UserGroupScript.new({user_items_text: "(xname) alice", order_by: order_by}, inside_options).call
        end
        assert { case1("grade")     }
        assert { case1("gentleman") }
        assert { case1("vitality")  }
        assert { case1("original")  }
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> QuickScript::Swars::UserGroupScript
# >>   通常の出力
# >> 2024-11-27T12:42:26.020Z pid=16924 tid=gw4 INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_xname=>"internal", :url=>"redis://localhost:6379/4"}
# >>   Google スプレッドシートに出力
# >>   順番 (FAILED - 1)
# >> 
# >> Failures:
# >> 
# >>   1) QuickScript::Swars::UserGroupScript 順番
# >>      Failure/Error: Unable to find - to read failed line
# >>      Minitest::Assertion:
# >>      # -:39:in `block (2 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >> 
# >> Top 3 slowest examples (5.37 seconds, 69.9% of total time):
# >>   QuickScript::Swars::UserGroupScript Google スプレッドシートに出力
# >>     4.92 seconds -:26
# >>   QuickScript::Swars::UserGroupScript 通常の出力
# >>     0.31452 seconds -:20
# >>   QuickScript::Swars::UserGroupScript 順番
# >>     0.13743 seconds -:34
# >> 
# >> Finished in 7.69 seconds (files took 2.56 seconds to load)
# >> 3 examples, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:34 # QuickScript::Swars::UserGroupScript 順番
# >> 
