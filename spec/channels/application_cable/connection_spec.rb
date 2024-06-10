require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  before do
    @user = User.create!
  end

  it "接続成功" do
    cookies.signed[:user_id] = @user.id
    connect "/maincable"
    assert { connection.current_user == @user }
  end

  xit "ユーザーの指定がないため接続拒否" do
    expect { connect "/maincable" }.to have_rejected_connection
  end

  it "存在しないユーザーからの接続拒否" do
    cookies.signed[:user_id] = -1
    expect { connect "/maincable" }.to have_rejected_connection
  end
end
