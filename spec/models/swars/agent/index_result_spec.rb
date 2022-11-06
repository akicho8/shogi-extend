require "rails_helper"

module Swars
  module Agent
    RSpec.describe IndexResult, type: :model, swars_spec: true do
      it "works" do
        index_result = IndexResult.empty
        assert { index_result.keys == [] }
        assert { index_result.last_page? }
      end
    end
  end
end
