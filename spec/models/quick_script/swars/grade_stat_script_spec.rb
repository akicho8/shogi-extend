require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe GradeStatScript, type: :model do
      def case1(params)
        instance = GradeStatScript.new(params)
        instance.as_json
        instance.total_count
      end

      it "works" do
        GradeStatScript::PrimaryAggregator.mock_setup
        GradeStatScript.primary_aggregate_call

        assert { case1({}) == 2 }
        assert { case1(tag: "居飛車") == 2 }
        assert { case1(tag: "オザワシステム") == 0 }
      end
    end
  end
end
