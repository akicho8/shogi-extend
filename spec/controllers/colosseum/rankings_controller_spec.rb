require 'rails_helper'

RSpec.describe Colosseum::RankingsController, type: :controller do
  it "index" do
    get :index
    expect(response).to have_http_status(:ok)
  end
end
