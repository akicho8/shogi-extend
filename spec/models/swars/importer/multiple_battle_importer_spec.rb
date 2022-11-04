require "rails_helper"

module Swars
  module Importer
    RSpec.describe MultipleBattleImporter, type: :model, swars_spec: true do
      it "works" do
        assert { Battle.count == 0 }
        MultipleBattleImporter.new(user_key: "devuser1", gtype: "").run
        assert { Battle.count == 3 }
      end
    end
  end
end
