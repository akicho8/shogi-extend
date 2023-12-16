require "rails_helper"

module ShareBoard
  RSpec.describe SenderInfo do
    it "bot" do
      assert { SenderInfo[:bot] }
      assert { SenderInfo[:bot].default_options_fn.call }
    end
    it "sysop" do
      assert { SenderInfo[:sysop] }
      assert { SenderInfo[:sysop].default_options_fn.call }
    end
  end
end
