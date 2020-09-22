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
end
