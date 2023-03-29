require "rails_helper"

RSpec.describe TinyUrl, type: :model do
  it "works" do
    assert2 { TinyUrl.from("https://example.com/") == "https://tinyurl.com/yqp7ct" }
  end
  it "引数がおかしい場合はエラーとせず引数をそのまま返す" do
    assert2 { TinyUrl.from("xxx") == "xxx" }
  end
end
