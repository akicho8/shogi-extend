require 'rails_helper'

RSpec.describe ScriptsController, type: :controller do
  before do
    Swars.setup
  end

  describe "すべてのスクリプト" do
    FrontendScript.bundle_scripts.each do |e|
      it e.script_name do
        get :show, params: { id: e.key }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "attack-rarity (json対応)" do
    before do
      get :show, params: { id: "swars-histograms", format: "json" }
    end
    let :value do
      JSON.parse(response.body)
    end
    it "json" do
      assert { value.find { |e| e["name"] == "嬉野流" } }
    end
  end
end
