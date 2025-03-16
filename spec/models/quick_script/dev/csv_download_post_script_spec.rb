require "rails_helper"

RSpec.describe QuickScript::Dev::CsvDownloadPostScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::CsvDownloadPostScript.new.as_json }
  end
end
