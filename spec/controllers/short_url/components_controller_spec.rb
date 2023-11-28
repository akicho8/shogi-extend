require "rails_helper"

RSpec.describe ShortUrl::ComponentsController, type: :controller do
  it "works" do
    original_url = "http://localhost:3000/"

    get :show, params: { original_url: original_url, format: "json" }
    assert { response.status == 200 }
    assert { response.body == ShortUrl.from(original_url) }
  end
end
