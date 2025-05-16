require "rails_helper"

RSpec.describe QuickScript::Dev::YoutubeIframeScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::YoutubeIframeScript.new.as_json }
  end
end
