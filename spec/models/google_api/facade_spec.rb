require "rails_helper"

module GoogleApi
  RSpec.describe Facade, type: :model do
    xit "works" do
      facade = GoogleApi::Facade.new(rows: [{id: 1}])
      assert { facade.rows == [[:id], [1]] }
      url = facade.call
      assert { url }
    end
  end
end
