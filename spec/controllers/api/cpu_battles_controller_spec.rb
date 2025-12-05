require "rails_helper"

RSpec.describe Api::CpuBattlesController, type: :controller do
  it "show" do
    get :show, params: { config_fetch: true }
    assert { response.status == 200 }
  end
  it "start_trigger" do
    post :create, params: { start_trigger: true }
    assert { response.status == 204 }
  end
  it "resign_trigger" do
    post :create, params: { resign_trigger: true }
    assert { response.status == 200 }
  end
  it "candidate_sfen" do
    post :create, params: { candidate_sfen: "68S", cpu_strategy_key: "オールラウンド", cpu_strategy_random_number: 0 }
    assert { response.status == 200 }
  end
  it "kifu_body" do
    post :create, params: { kifu_body: "68S", cpu_strategy_key: "オールラウンド", cpu_strategy_random_number: 0 }
    assert { response.status == 200 }
  end
end
