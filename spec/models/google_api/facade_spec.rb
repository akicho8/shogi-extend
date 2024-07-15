require "rails_helper"

module GoogleApi
  RSpec.describe Facade, type: :model do
    it "works" do
      Timecop.return do
        facade = Facade.new(rows: [{id: 1}])
        assert { facade.rows == [[:id], [1]] }
        assert { facade.call }
        ExpirationTracker.destroy_all
      end
    end
  end
end
