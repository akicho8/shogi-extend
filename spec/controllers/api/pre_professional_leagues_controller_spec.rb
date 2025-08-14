require "rails_helper"

RSpec.describe Api::PreProfessionalLeaguesController, type: :controller, swars_spec: true do
  it "works" do
    get :show, params: { generation: -1 }
    assert { response.status == 404 }
  end
end
