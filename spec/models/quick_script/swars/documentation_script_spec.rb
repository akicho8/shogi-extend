require "rails_helper"

module QuickScript
  RSpec.describe Swars::DocumentationScript, type: :model do
    it "works" do
      assert { Swars::DocumentationScript.new.call }
    end

    it "継承の継承だけど Dispatcher.all に出てくる" do
      assert { Dispatcher.all.include?(Swars::DocumentationScript) }
    end
  end
end
