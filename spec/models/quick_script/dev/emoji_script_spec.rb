require "rails_helper"

module QuickScript
  RSpec.describe Dev::EmojiScript, type: :model do
    it "works" do
      assert { Dev::EmojiScript.new.as_json }
    end
  end
end
