require 'rails_helper'

RSpec.describe AuthInfo, type: :model do
  include ActiveJob::TestHelper

  before(:context) do
    Actb.setup
  end

  it "SNS経由で登録すると通知" do
    user = User.create!
    perform_enqueued_jobs do
      user.auth_infos.create!(provider: "twitter", uid: SecureRandom.hex)
    end
    assert { ActionMailer::Base.deliveries.count == 1 }
    # tp ActionMailer::Base.deliveries.collect { |e| {subject: e.subject, from: e.from, to: e.to} }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.53939 seconds (files took 2.22 seconds to load)
# >> 1 example, 0 failures
# >> 
