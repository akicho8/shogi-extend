require 'rails_helper'

module Swars
  RSpec.describe MembershipMedalInfo, type: :model do
    before do
      Swars.setup
    end

    describe "タグ依存メダル" do
      def test(tactic_keys, win_or_lose)
        black = User.create!
        white = User.create!
        tactic_keys.each do |e|
          Battle.create!(tactic_key: e) do |e|
            e.memberships.build(user: black, judge_key: win_or_lose)
            e.memberships.build(user: white)
          end
        end
        {black: black, white: white}.inject({}) { |a, (k, v)|
          a.merge(k => v.memberships.first.first_matched_medal.key.to_s)
        }
      end

      def b(*tactic_keys)
        test(tactic_keys, :win)[:black]
      end

      def w(*tactic_keys)
        test(tactic_keys, :lose)[:white]
      end

      it do
        assert { b("角不成")   == "角不成マン"   }
        assert { b("飛車不成") == "飛車不成マン" }
        assert { b("背水の陣") == "背水マン"     }
      end
    end

    describe "切断マン" do
      before do
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597]], final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
      end

      it do
        assert { @black.memberships.first.first_matched_medal.key == :"切断マン" }
      end
    end

    describe "絶対投了しないマン" do
      before do
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597]], final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
      end

      it do
        assert { @black.memberships.first.first_matched_medal.key == :"絶対投了しないマン" }
      end
    end

    describe "1手詰じらしマン" do
      before do
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
      end

      it do
        assert { @black.memberships.first.first_matched_medal.key == :"1手詰じらしマン" }
      end
    end

    describe "長考" do
      def test(min)
        seconds = min.minutes

        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end

        @black.memberships.first.first_matched_medal.key
      end

      it do
        assert { test(2.5) == :"長考マン"   }
        assert { test(3.0) == :"大長考マン" }
      end
    end

    describe "ただの千日手" do
      def csa_seq_generate(n)
        [["+5958OU", 600], ["-5152OU", 600], ["+5859OU", 600], ["-5251OU", 600]] * n
      end

      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :DRAW_SENNICHI) do |e|
          e.memberships.build(user: @black, judge_key: :draw)
          e.memberships.build(user: @white, judge_key: :draw)
        end
        @black.memberships.first.first_matched_medal.key
      end

      it do
        assert { test(4) == :"ただの千日手" }
        assert { test(3) == :"開幕千日手"   }
      end
    end

    describe "切れ負けマン" do
      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - i * 30.seconds
          [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds], ["-5251OU", seconds]]
        end
      end

      before do
        @black = User.create!
        @white = User.create!

        Swars::Battle.create!(csa_seq: csa_seq_generate(20), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
      end

      it do
        assert { @black.memberships.first.first_matched_medal.key == :"切れ負けマン" }
      end
    end

    describe "棋神マン" do
      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - (i * 4.seconds)
          [["+5958OU", seconds], ["-5152OU", seconds], ["+5859OU", seconds - 2], ["-5251OU", seconds]]
        end
      end

      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate(n), final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.memberships.first.first_matched_medal.key
      end

      it do
        assert { test(20) == :"棋神マン" }
      end
    end

    describe "段級差" do
      def test(*keys)
        Battle.create! do |e|
          keys.each do |key|
            e.memberships.build(user: User.create!(grade: Grade.find_by(key: key)))
          end
        end
      end

      it do
        assert { test("初段", "二段").memberships[0].first_matched_medal.key == :"段級位差" }
      end

      it do
        battle = test("初段", "二段")
        assert { battle.memberships[0].medal_params == {:icon => "numeric-1-circle",      :class => "has-text-gold"       }}
        assert { battle.memberships[1].medal_params == {:icon => "emoticon-dead-outline", :class => "has-text-grey-light" }}
      end
    end
  end
end
