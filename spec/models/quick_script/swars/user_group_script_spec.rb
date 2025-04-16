require "rails_helper"

RSpec.describe QuickScript::Swars::UserGroupScript, type: :model do
  def case1
    ::Swars::User.create!(key: "a")
    ::Swars::User.create!(key: "b")
    ::Swars::User.create!(key: "c")
  end

  def inside_options
    { _method: "post", current_user: User.create! }
  end

  def user_items_text
    ["(xname) a", "(xname) b"].join("\n")
  end

  it "通常の出力" do
    case1
    response = QuickScript::Swars::UserGroupScript.new({ user_items_text: user_items_text }, inside_options).call
    assert { response[:_v_bind][:value][:rows].size == 2 }
  end

  it "Google スプレッドシートに出力" do
    case1
    Timecop.return do
      assert { QuickScript::Swars::UserGroupScript.new({ user_items_text: user_items_text, google_sheet: "true" }, inside_options).as_json[:redirect_to] }
      GoogleApi::ExpirationTracker.destroy_all
    end
  end

  it "順番" do
    ::Swars::User.create!(key: "alice")
    def case1(order_by)
      QuickScript::Swars::UserGroupScript.new({ user_items_text: "(xname) alice", order_by: order_by }, inside_options).call
    end
    assert { case1("grade")     }
    assert { case1("gentleman") }
    assert { case1("vitality")  }
    assert { case1("original")  }
  end
end
