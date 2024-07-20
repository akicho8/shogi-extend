require "rails_helper"

module QuickScript
  RSpec.describe Dev::BackgroundJobScript, type: :model do
    it "works" do
      assert { Dev::BackgroundJobScript.new.call == nil }
      assert { Dev::BackgroundJobScript.new({_method: "post"}).call == {:_autolink=>nil} }
      assert { Dev::BackgroundJobScript.new({}, background_mode: true).call.kind_of?(AppLog) }
    end
  end
end
