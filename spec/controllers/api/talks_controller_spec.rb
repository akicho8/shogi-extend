require "rails_helper"

RSpec.describe Api::TalksController, type: :controller do
  around { |e| Timecop.return { e.run } }

  it "create" do
    post :create, params: { source_text: "(source_text)" }
    value = JSON.parse(response.body, symbolize_names: true)
    assert { value[:browser_path] }
  end
end
