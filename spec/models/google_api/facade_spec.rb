require "rails_helper"

RSpec.describe GoogleApi::Facade, type: :model do
  it "works" do
    Timecop.return do
      facade = GoogleApi::Facade.new(rows: [{id: 1}])
      assert { facade.rows == [[:id], [1]] }
      assert { facade.call }
      GoogleApi::ExpirationTracker.destroy_all
    end
  end
end
