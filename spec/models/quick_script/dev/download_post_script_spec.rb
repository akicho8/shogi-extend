require "rails_helper"

module QuickScript
  RSpec.describe Dev::DownloadPostScript, type: :model do
    it "works" do
      assert { Dev::DownloadPostScript.new.as_json }
    end
  end
end
