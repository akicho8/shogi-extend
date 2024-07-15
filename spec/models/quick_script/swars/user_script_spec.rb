require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe UserScript, type: :model do
      def case1
        ::Swars::User.create!(key: "a")
        ::Swars::User.create!(key: "b")
        ::Swars::User.create!(key: "c")
      end

      it "通常の出力" do
        case1
        assert { UserScript.new(user_keys: "a, b").call[:rows].size == 2 }
      end

      it "Google スプレッドシートに出力" do
        case1
        Timecop.return do
          assert { UserScript.new(user_keys: "a, b", google_sheet: "true").as_json[:redirect_to] }
          GoogleApi::ExpirationTracker.destroy_all
        end
      end

      it "順番" do
        ::Swars::User.create!(key: "alice")
        def case1(order_by)
          UserScript.new(user_keys: "alice", order_by: order_by).call
        end
        assert { case1("grade")     }
        assert { case1("gentleman") }
        assert { case1("vitality")  }
        assert { case1("original")  }
      end
    end
  end
end
