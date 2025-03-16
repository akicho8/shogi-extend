require "rails_helper"

RSpec.describe QuickScript::Dev::EmojiScript, type: :model do
  it "works" do
    assert { QuickScript::Dev::EmojiScript.new.as_json }
  end
end
