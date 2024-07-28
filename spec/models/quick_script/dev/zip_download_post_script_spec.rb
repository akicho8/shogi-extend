require "rails_helper"

module QuickScript
  RSpec.describe Dev::ZipDownloadPostScript, type: :model do
    it "works" do
      assert { Dev::ZipDownloadPostScript.new({}, {_method: "post"}).as_json }
    end
  end
end
