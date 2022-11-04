require "rails_helper"

module Swars
  module Importer
    RSpec.describe UserImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        UserImporter.new(user_key: "devuser1").run
        assert { Battle.count == 3 }
        UserImporter.new(user_key: "devuser1").run
        assert { Battle.count == 3 }
      end
    end
  end
end
