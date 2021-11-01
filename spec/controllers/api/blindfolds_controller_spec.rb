require "rails_helper"

RSpec.describe Api::BlindfoldsController, type: :controller do
  it "works" do
    get :show
    assert { response.status == 200 }
  end
end
