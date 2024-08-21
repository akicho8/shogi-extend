require "rails_helper"

module QuickScript
  module Swars
    RSpec.describe TacticStatScript, type: :model do
      def case1
        black = ::Swars::User.create!
        ::Swars::Battle.create!(csa_seq: ::Swars::KifuGenerator.generate_n(14)) do |e|
          e.memberships.build(user: black)
        end
        ::Swars::TagJudgeItem.create_new_generation_items(scope: black.memberships)
      end

      it "works" do
        case1
        assert { TacticStatScript.new({tactic_key: :attack, count_gteq: 0}).as_json }
        assert { TacticStatScript.new({tactic_key: :note, count_gteq: 0}).as_json }
      end
    end
  end
end
