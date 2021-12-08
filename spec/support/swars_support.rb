module SwarsSupport
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    before(:context) do
      Swars::Battle.destroy_all
    end

    before do
      Swars.setup
      Swars::Battle.user_import(user_key: "devuser1")
    end
  end
end
