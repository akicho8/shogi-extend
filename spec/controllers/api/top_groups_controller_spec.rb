require "rails_helper"

RSpec.describe Api::TopGroupsController, type: :controller do
  include SwarsSupport

  it "works" do
    get :show
    assert { response.status == 200 }
  end
end
