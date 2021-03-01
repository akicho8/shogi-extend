require 'rails_helper'

RSpec.describe User, type: :model do
  include ActiveJob::TestHelper

  # before(:context) do
  #   Actb.setup
  # end

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
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 1.82 seconds (files took 3.62 seconds to load)
# >> 3 examples, 0 failures
# >> 
