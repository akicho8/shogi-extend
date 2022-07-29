require "rails_helper"

RSpec.describe Api::TopGroupsController, type: :controller do
  include SwarsSupport

  it "「将棋ウォーズイベント上位の成績」が見える" do
    get :show
    assert { response.status == 200 }
  end
end
