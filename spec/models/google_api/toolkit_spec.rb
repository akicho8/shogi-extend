require "rails_helper"

module GoogleApi
  RSpec.describe Toolkit, type: :model do
    it "works" do
      Timecop.return do
        toolkit = Toolkit.new
        spreadsheet = toolkit.spreadsheet_create
        toolkit.spreadsheet_delete(spreadsheet.spreadsheet_id)
      end
    end
  end
end
