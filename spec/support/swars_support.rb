module SwarsSupport
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    before do
      swars_battle_setup
    end

    def swars_battle_setup
      Swars.setup
      Swars::Battle.user_import(user_key: "devuser1")
    end
  end
end
