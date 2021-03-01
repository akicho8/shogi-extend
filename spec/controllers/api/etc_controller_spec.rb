require "rails_helper"

RSpec.describe Api::EtcController, type: :controller do
  it "ping" do
    get :ping
    assert { response.status == 200 }
  end

  it "echo" do
    get :echo, params: { message: "ok" }
    assert { response.status == 200 }
  end
end
