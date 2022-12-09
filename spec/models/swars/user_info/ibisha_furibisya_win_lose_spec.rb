require "rails_helper"

module Swars
  RSpec.describe UserInfo::IbishaFuribishaWinLose, type: :model, swars_spec: true do
    describe "居飛車 ibisya_win_lose_params" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        if params = @black.user_info.ibisha_furibisha_win_lose.ibisya_win_lose_params
          params[:judge_counts]
        end
      end

      it "works" do
        assert { case1(ibisya_csa_seq_generate(13)) == nil }
        assert { case1(ibisya_csa_seq_generate(14)) == { win: 1, lose: 0 } }
      end
    end

    describe "振り飛車 furibisha_win_lose_params" do
      before do
        @black = User.create!
      end

      def case1(csa_seq)
        Battle.create!(csa_seq: csa_seq) do |e|
          e.memberships.build(user: @black)
        end
        if params = @black.user_info.ibisha_furibisha_win_lose.furibisha_win_lose_params
          params[:judge_counts]
        end
      end

      it "works" do
        assert { case1(furibisha_csa_seq_generate(13)) == nil }
        assert { case1(furibisha_csa_seq_generate(14)) == { win: 1, lose: 0 } }
      end
    end
  end
end
