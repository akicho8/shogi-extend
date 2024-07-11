require "rails_helper"

module SheetHandler
  RSpec.describe SheetFacade, type: :model do
    xit "works" do
      sheet_facade = SheetHandler::SheetFacade.new(rows: [{id: 1}])
      assert { sheet_facade.rows == [[:id], [1]] }
      response = sheet_facade.call
      assert { response[:url] }
    end
  end
end
