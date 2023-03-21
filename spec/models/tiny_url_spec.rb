require "rails_helper"

RSpec.describe TinyUrl, type: :model do
  it "works" do
    is_asserted_by { TinyUrl.from("https://example.com/") == "https://tinyurl.com/yqp7ct" }
  end
  it "引数がおかしい場合はエラーとせず引数をそのまま返す" do
    is_asserted_by { TinyUrl.from("xxx") == "xxx" }
  end
end
