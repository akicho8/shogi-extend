require 'rails_helper'

RSpec.describe "FreeBattles", type: :request do
  before do
    @free_battle = FreeBattle.create!
  end

  it "/x" do
    get free_battles_path
    expect(response).to have_http_status(200)
  end

  it "/x?modal_id=xxx" do
    get free_battles_path(modal_id: @free_battle.to_param)
    expect(response).to have_http_status(200)
  end
end
