require "rails_helper"

module QuickScript
  RSpec.describe Dev::CsvDownloadGetScript, type: :model do
    it "works" do
      assert { Dev::CsvDownloadGetScript.new.as_json }
    end
  end
end
