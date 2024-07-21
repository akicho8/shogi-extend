require "rails_helper"

module QuickScript
  RSpec.describe Dev::CsvDownloadPostScript, type: :model do
    it "works" do
      assert { Dev::CsvDownloadPostScript.new.as_json }
    end
  end
end
