require "rails_helper"

RSpec.describe TopsController, type: :controller do
  it "トップページが見える" do
    get :show
    assert { response.status == 200 }
  end

  # http://localhost:3000/?test_request_info=1
  it "エラー時にリクエスト情報を含める" do
    get :show, params: { test_request_info: "1" }
    assert { response.status == 200 }
    assert { ActionMailer::Base.deliveries.last.body.include?("HTTP_USER_AGENT") }
  end

  # http://localhost:3000/?force_error=1
  it "エラーを発生させる" do
    proc { get :show, params: { force_error: "1" } }.should raise_error(ZeroDivisionError)
  end
end
