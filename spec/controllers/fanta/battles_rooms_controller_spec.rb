require 'rails_helper'

RSpec.describe Fanta::BattlesController, type: :controller do
  before do
    @current_user = user_login
  end

  it "index" do
    get :index
    expect(response).to have_http_status(:ok)
  end

  it "show" do
    @user1 = create(:fanta_user)
    @user2 = create(:fanta_user)
    @battle = Fanta::Battle.create!
    @battle.users << @user1
    @battle.users << @user1

    get :show, params: {id: @battle.id}
    expect(response).to have_http_status(:ok)
  end
end
