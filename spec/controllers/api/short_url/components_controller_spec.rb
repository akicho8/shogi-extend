require "rails_helper"

RSpec.describe Api::ShortUrl::ComponentsController, type: :controller do
  it "works" do
    record = ShortUrl.from("/")
    post :create, params: { original_url: "/", format: "json" }
    assert { response.status == 200 }
    assert { response.body == record.compact_url }
  end
end
