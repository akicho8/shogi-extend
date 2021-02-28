require "rails_helper"

RSpec.describe Api::TalksController, type: :controller do
  it "show" do
    get :show, params: { source_text: "(source_text)" }
    value = JSON.parse(response.body, symbolize_names: true)
    value # => {:browser_path=>"/system/talk/3c/88/3c88a9017fb38f0572360f7b03c507c8.mp3"}
    assert { value[:browser_path].include?(".mp3") }
    assert { value[:browser_path].start_with?("/system") }
  end

  it "create" do
    post :create, params: { source_text: "(source_text)" }
    value = JSON.parse(response.body, symbolize_names: true)
    assert { value[:browser_path] }
  end
end
