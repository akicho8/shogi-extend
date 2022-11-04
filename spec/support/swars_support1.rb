module SwarsSupport1
  extend ActiveSupport::Concern

  included do
    include ActiveJob::TestHelper # for perform_enqueued_jobs

    before(:context) do
      Swars::Battle.destroy_all
    end

    before do
      Swars.setup
      Swars::Importer::UserImporter.new(user_key: "devuser1").run
    end
  end
end
