require "rails_helper"

module QuickScript
  RSpec.describe Chore::SitemapScript, type: :model do
    it "works" do
      assert { Chore::SitemapScript.new.as_json[:body] } # nuxt.config.js と合わせる
    end
  end
end
