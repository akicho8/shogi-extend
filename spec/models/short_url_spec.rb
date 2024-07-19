require "rails_helper"

RSpec.describe ShortUrl, type: :model do
  it "works" do
    assert { ShortUrl["xxx"] == "http://localhost:3000/u/zC3CzFn5jev" }
    assert { ShortUrl.transform("xxx") == "http://localhost:3000/u/zC3CzFn5jev" }
    assert { ShortUrl.from("xxx") }
    assert { ShortUrl.key("xxx") == "zC3CzFn5jev" }
  end
end
