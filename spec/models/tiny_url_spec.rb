require "rails_helper"

RSpec.describe TinyUrl, type: :model do
  it "works" do
    # 実行する PC によって http や https になったりするのは謎
    assert { TinyUrl.from("https://example.com/").match?(%{https?://tinyurl.com/yqp7ct}) }
  end

  it "引数がおかしい場合はエラーとせず引数をそのまま返す" do
    assert { TinyUrl.from("xxx") == "xxx" }
  end

  it "2023-04-06 から localhost が含まれると失敗するようになった" do
    assert { TinyUrl.create("http://localhost/") == nil }
  end
end
