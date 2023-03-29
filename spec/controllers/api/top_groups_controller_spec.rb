require "rails_helper"

RSpec.describe Api::TopGroupsController, type: :controller do
  include SwarsSupport1

  it "「将棋ウォーズイベント上位の成績」が見える" do
    get :show
    assert2 { response.status == 200 }
  end
end
