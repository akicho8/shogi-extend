require "rails_helper"

RSpec.describe Api::TalksController, type: :controller do
  it "create" do
    post :create, params: { source_text: "(source_text)" }
    value = JSON.parse(response.body, symbolize_names: true)
    assert2 { value[:browser_path] }
  end
end
