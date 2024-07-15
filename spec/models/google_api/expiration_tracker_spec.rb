require "rails_helper"

module GoogleApi
  RSpec.describe ExpirationTracker, type: :model do
    it "プレッドシートを作ったあとで削除する" do
      Timecop.return do
        assert { ExpirationTracker.count == 0 }
        Facade.new(rows: [{id: 1}]).call
        assert { ExpirationTracker.count == 1 }
        ExpirationTracker.destroy_all
      end
    end
  end
end
