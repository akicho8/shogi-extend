require "rails_helper"

RSpec.describe QuickScript::Dev::CsvDownloadGetScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::CsvDownloadGetScript.new.as_json }
  end
end
