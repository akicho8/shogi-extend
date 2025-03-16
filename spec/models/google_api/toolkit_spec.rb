require "rails_helper"

RSpec.describe GoogleApi::Toolkit, type: :model do
  it "works" do
    Timecop.return do
      toolkit = GoogleApi::Toolkit.new
      spreadsheet = toolkit.spreadsheet_create
      toolkit.spreadsheet_delete(spreadsheet.spreadsheet_id)
    end
  end
end
