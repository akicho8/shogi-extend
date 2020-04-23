require 'rails_helper'

RSpec.describe ShareBoardsController, type: :controller do
  it "show" do
    get :show
    expect(response).to have_http_status(:ok)
  end
end
