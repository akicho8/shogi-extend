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
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.13 seconds (files took 2.75 seconds to load)
# >> 2 examples, 0 failures
# >> 
