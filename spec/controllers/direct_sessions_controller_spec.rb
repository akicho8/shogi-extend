require "rails_helper"

RSpec.describe DirectSessionsController, type: :controller do
  it "create" do
    post :create
    assert { response.status == 302 }
  end

  it "destroy" do
    delete :destroy
    assert { response.status == 302 }
  end
end
