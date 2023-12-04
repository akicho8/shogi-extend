require "rails_helper"

RSpec.describe ShortUrl::ComponentsController, type: :controller do
  it "works" do
    record = ShortUrl::Component.from("/")
    get :show, params: { key: record.key }
    assert { response.status == 302 }
  end
end
