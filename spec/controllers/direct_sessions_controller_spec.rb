require 'rails_helper'

RSpec.describe DirectSessionsController, type: :controller do
  it "create" do
    post :create
    expect(response).to have_http_status(:redirect)
  end

  it "destroy" do
    delete :destroy
    expect(response).to have_http_status(:redirect)
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.29059 seconds (files took 2.13 seconds to load)
# >> 2 examples, 0 failures
# >> 
