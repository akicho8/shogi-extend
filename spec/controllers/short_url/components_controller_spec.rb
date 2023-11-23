require "rails_helper"

RSpec.describe ShortUrl::ComponentsController, type: :controller do
  it "works" do
    original_url = "http://localhost:3000/"
    get :show, params: { original_url: original_url, format: "json" }
    assert2 { response.status == 200 }
    record = JSON.parse(response.body, symbolize_names: true)
    assert2 { record[:original_url] == original_url }
  end
end
