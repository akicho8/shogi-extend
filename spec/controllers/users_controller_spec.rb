require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    @current_user = user_login
  end

  describe "show" do
    it "works" do
      get :show, params: { id: @current_user.id }
      assert { response.status == 200 }
    end
  end

  describe "edit" do
    it "works" do
      get :edit, params: { id: @current_user.id }
      assert { response.status == 200 }
    end
  end

  describe "update" do
    it "works" do
      name = SecureRandom.hex
      user = { name: name, avatar: fixture_file_upload("spec/files/rails.png", "image/png") }
      put :update, params: { id: @current_user.id, user: user }
      assert { response.status == 302 }

      @current_user.reload
      assert { @current_user.name == name                        }
      assert { @current_user.avatar.filename.to_s == "rails.png" }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 1.57 seconds (files took 2.51 seconds to load)
# >> 3 examples, 0 failures
# >> 
