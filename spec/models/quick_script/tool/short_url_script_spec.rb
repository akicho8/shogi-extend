require "rails_helper"

RSpec.describe QuickScript::Tool::ShortUrlScript, type: :model do
  it "works" do
    assert { QuickScript::Tool::ShortUrlScript.new(_method: :post, original_url: "http://localhost:3000/").call == { _autolink: "http://localhost:3000/u/zZSGrCkrLPo" } }
  end
end
