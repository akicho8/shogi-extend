require "rails_helper"

RSpec.describe QuickScript::Chore::SitemapScript, type: :model do
  it "works" do
    assert { QuickScript::Chore::SitemapScript.new.as_json[:body] } # nuxt.config.js と合わせる
  end
end
