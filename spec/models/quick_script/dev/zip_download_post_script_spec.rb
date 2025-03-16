require "rails_helper"

RSpec.describe QuickScript::Dev::ZipDownloadPostScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::ZipDownloadPostScript.new({}, {_method: "post"}).as_json }
  end
end
