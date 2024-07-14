require "rails_helper"

module QuickScript
  RSpec.describe Dev::DownloadGetScript, type: :model do
    it "works" do
      assert { Dev::DownloadGetScript.new.as_json }
    end
  end
end
