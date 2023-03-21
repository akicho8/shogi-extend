require "rails_helper"

module Swars
  RSpec.describe "居飛車と振り飛車の勝率", type: :model, swars_spec: true do
    describe "ibisha_note_judge_info" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        if params = @black.user_info.ibisha_note_judge_info.to_chart
          params[:judge_counts]
        end
      end

      it "works" do
        is_asserted_by { case1(ibisha_csa_seq_generate(13)) == nil }
        is_asserted_by { case1(ibisha_csa_seq_generate(14)) == { win: 1, lose: 0 } }
      end
    end

    describe "furibisha_note_judge_info" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        if params = @black.user_info.furibisha_note_judge_info.to_chart
          params[:judge_counts]
        end
      end

      it "works" do
        is_asserted_by { case1(furibisha_csa_seq_generate(13)) == nil }
        is_asserted_by { case1(furibisha_csa_seq_generate(14)) == { win: 1, lose: 0 } }
      end
    end
  end
end
