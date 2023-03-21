require "rails_helper"

RSpec.describe Api::EtcController, type: :controller do
  it "ping" do
    get :ping
    is_asserted_by { response.status == 200 }
  end

  it "echo" do
    get :echo, params: { message: "ok" }
    is_asserted_by { response.status == 200 }
  end
end
