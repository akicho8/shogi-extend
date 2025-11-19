require "rails_helper"

RSpec.describe User, type: :model do
  include ActiveJob::TestHelper

  it "create! のときに confirmed_at を設定するとメール認証が飛ばない" do
    perform_enqueued_jobs do
      User.create!(email: "alice@example.com", confirmed_at: Time.current)
      assert { ActionMailer::Base.deliveries.count == 0 }
    end
  end

  it "email をあとから更新するとメール認証が飛び、いったん unconfirmed_email に退避されるので注意" do
    user = User.create!(email: "alice@example.com", confirmed_at: Time.current)
    user.email = "new@example.com"
    user.save!
    assert { user.email == "alice@example.com"           }
    assert { user.unconfirmed_email == "new@example.com" }
    assert { ActionMailer::Base.deliveries.count == 1    }
  end

  it "email を確実に更新するときは skip_reconfirmation! を実行する" do
    user = User.create!(email: "alice@example.com", confirmed_at: Time.current)
    user.email = "new@example.com"
    user.skip_reconfirmation!
    user.save!
    assert { user.email == "new@example.com" }
    assert { ActionMailer::Base.deliveries.count == 0 }
  end

  it "emailが重複したときのエラーメッセージが利用者向けの案内になっている" do
    User.create!(email: "alice@example.com", confirmed_at: Time.current)
    user = User.create(email: "alice@example.com", confirmed_at: Time.current)
    assert { user.errors.full_messages.join.include?("メールアドレスとパスワードでログインしよう") }
  end
end
