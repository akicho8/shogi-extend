require "rails_helper"

module QuickScript
  RSpec.describe Swars::PiyoShogiConfigScript, type: :model do
    it "works" do
      json = Swars::PiyoShogiConfigScript.new({}, {_method: "post"}).as_json
      assert { json[:flash][:notice].match?(/保存/) }
    end
  end
end
