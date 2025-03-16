require "rails_helper"

RSpec.describe GoogleApi::ExpirationTracker, type: :model do
  it "プレッドシートを作ったあとで削除する" do
    Timecop.return do
      assert { GoogleApi::ExpirationTracker.count == 0 }
      GoogleApi::Facade.new(rows: [{id: 1}]).call
      assert { GoogleApi::ExpirationTracker.count == 1 }
      GoogleApi::ExpirationTracker.destroy_all
    end
  end
end
