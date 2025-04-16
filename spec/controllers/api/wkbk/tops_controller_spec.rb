require "rails_helper"

RSpec.describe Api::Wkbk::TopsController, type: :controller do
  include WkbkSupportMethods

  it "index" do
    user_login(User.admin)
    get :index
    assert { response.status == 200 }
  end

  it "sitemap" do
    get :sitemap
    assert { response.status == 200 }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >>
# >> Finished in 4.45 seconds (files took 2.89 seconds to load)
# >> 2 examples, 0 failures
# >>
