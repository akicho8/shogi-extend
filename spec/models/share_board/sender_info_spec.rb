require "rails_helper"

module ShareBoard
  RSpec.describe SenderInfo do
    it "bot" do
      assert { SenderInfo[:bot] }
      assert { SenderInfo[:bot].default_options_fn.call }
    end
    it "admin" do
      assert { SenderInfo[:admin] }
      assert { SenderInfo[:admin].default_options_fn.call }
    end
  end
end
