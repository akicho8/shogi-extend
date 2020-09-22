require "rails_helper"

RSpec.describe Api::EtcController, type: :controller do
  it "ping" do
    get :ping
    expect(response).to have_http_status(:ok)
  end

  it "echo" do
    get :echo, params: { message: "ok" }
    expect(response).to have_http_status(:ok)
  end
end
