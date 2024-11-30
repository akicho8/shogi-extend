require "rails_helper"

module QuickScript
  RSpec.describe Middleware::ParentLinkMod, type: :model do
    it "back_to で指定された URL は最優先で parent_link に設定する" do
      url = Object.new
      object = QuickScript::Dev::NullScript.new(back_to: url)
      object.parent_link = SecureRandom.hex # ここで設定したものより back_to を優先する
      assert { object.as_json[:parent_link] == { force_link_to: url } }
    end
  end
end
