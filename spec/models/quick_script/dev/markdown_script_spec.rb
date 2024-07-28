require "rails_helper"

module QuickScript
  RSpec.describe Dev::MarkdownScript, type: :model do
    it "works" do
      assert { Dev::MarkdownScript.new.call }
    end
  end
end
