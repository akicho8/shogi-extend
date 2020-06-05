require "rails_helper"

RSpec.describe ApplicationCable::Connection, type: :channel do
  let_it_be(:user) { User.create! }

  it "接続成功" do
    cookies.signed[:user_id] = user.id
    connect "/x-cable"
    expect(connection.current_user).to eq user
  end

  it "ユーザーの指定がないため接続拒否" do
    expect { connect "/x-cable" }.to have_rejected_connection
  end

  it "存在しないユーザーからの接続拒否" do
    cookies.signed[:user_id] = -1
    expect { connect "/x-cable" }.to have_rejected_connection
  end
end
