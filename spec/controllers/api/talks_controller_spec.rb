require "rails_helper"

RSpec.describe Api::TalksController, type: :controller do
  it "create" do
    post :create, params: { source_text: "(source_text)" }
    value = JSON.parse(response.body, symbolize_names: true)
    is_asserted_by { value[:browser_path] }
  end
end
