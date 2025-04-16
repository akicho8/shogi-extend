require "rails_helper"

RSpec.describe GoogleApi::ExpirationTracker, type: :model do
  before do
    Timecop.return do
      GoogleApi::ExpirationTracker.destroy_all
    end
  end

  after do
    Timecop.return do
      GoogleApi::ExpirationTracker.destroy_all
    end
  end

  it "プレッドシートを作ったあとで削除する" do
    Timecop.return do
      GoogleApi::Facade.new(rows: [{ id: 1 }]).call
      assert { GoogleApi::ExpirationTracker.count == 1 }
    end
  end
end
