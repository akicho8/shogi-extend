require "rails_helper"

module Swars
  RSpec.describe User::Stat::WinStat, type: :model, swars_spec: true do
    def case1(tactic_keys, judge_key, n_times = 1)
      @black = User.create!
      n_times.times do
        tactic_keys.each do |strike_plan|
          Battle.create!(strike_plan: strike_plan) do |e|
            e.memberships.build(user: @black, judge_key: judge_key)
          end
        end
      end
    end

    describe "methods" do
      describe "重要" do
        it "ratios_hash" do
          case1(["棒銀"], :lose)
          assert { @black.stat.win_stat.to_h == {} }
          case1(["棒銀"], :win)
          assert { @black.stat.win_stat.to_h[:"棒銀"] == 1.0 }
        end

        it "tags" do
          case1(["棒銀"], :win)
          assert { @black.stat.win_stat.tags.include?(:"棒銀") }
        end

        it "to_s" do
          case1(["棒銀"], :win)
          assert { @black.stat.win_stat.to_s.include?(",") }
        end
      end

      describe "ヘルパー" do
        before do
          case1(["棒銀"], :win)
        end

        it "exist?" do
          assert { @black.stat.win_stat.exist?(:"棒銀") }
        end

        it "include?" do
          assert { @black.stat.win_stat.include?("棒") }
        end

        it "match?" do
          assert { @black.stat.win_stat.match?(/棒/) }
        end
      end

      describe "派閥" do
        it "the_ture_master_of_ibis? / 居飛車党" do
          case1(["棒銀"], :win, 10)
          assert { @black.stat.win_stat.the_ture_master_of_ibis? }
        end

        it "the_ture_master_of_furi? / 振り飛車党" do
          case1(["四間飛車"], :win, 10)
          assert { @black.stat.win_stat.the_ture_master_of_furi? }
        end

        it "the_ture_master_of_all_rounder? / オールランダー" do
          case1(["棒銀", "四間飛車"], :win, 10)
          assert { @black.stat.win_stat.the_ture_master_of_all_rounder? }
        end
      end
    end
  end
end
