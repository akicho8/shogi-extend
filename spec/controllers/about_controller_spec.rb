require 'rails_helper'

RSpec.describe AboutController, type: :controller do
  it "privacy_policy" do
    get :show, params: {id: :privacy_policy}
    expect(response).to be_successful
  end

  it "terms" do
    get :show, params: {id: :terms}
    expect(response).to be_successful
  end

  it "asct" do
    get :show, params: {id: :asct}
    expect(response).to be_successful
  end
end
