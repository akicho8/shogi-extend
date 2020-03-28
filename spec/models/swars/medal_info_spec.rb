require 'rails_helper'

module Swars
  RSpec.describe type: :model do
    before do
      Swars.setup
    end

    let :user do
      User.create!
    end

    describe "タグ依存メダル" do
      def test(tactic_keys)
        black = User.create!
        white = User.create!
        tactic_keys.each do |e|
          Battle.create!(tactic_key: e) do |e|
            e.memberships.build(user: black)
            e.memberships.build(user: white)
          end
        end
        [black, white].collect { |e|
          e.user_info.medal_list.matched_medal_infos.collect(&:key).collect(&:to_s)
        }
      end

      def b(*tactic_keys)
        test(tactic_keys)[Bioshogi::Location.fetch(:black).code]
      end

      def w(*tactic_keys)
        test(tactic_keys)[Bioshogi::Location.fetch(:white).code]
      end

      it do
        assert { b("棒銀").include?("居飛車党")                   }
        assert { b("早石田").include?("振り飛車党")               }
        assert { b("棒銀", "早石田").include?("オールラウンダー") }
        assert { b("ロケット").include?("ロケットマン")           }
        assert { b("嬉野流").include?("嬉野マン")                 }
        assert { w("パックマン戦法").include?("パックマン")       }
        assert { b("耀龍四間飛車").include?("耀龍マン")           }
        assert { b("耀龍ひねり飛車").include?("耀龍マン")         }
        assert { b("アヒル囲い").include?("アヒル上級")           }
        assert { b("UFO銀").include?("UFOマン")                   }
        assert { b("裏アヒル囲い").include?("レアマン")           }
      end
    end

    describe "切れ負けマン" do
      before do
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597]], final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
      end

      it do
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).collect(&:to_s).include?("切れ負けマン") }
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
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).collect(&:to_s).include?("切断マン") }
      end
    end

    describe "居玉勝ちマン" do
      before do
        Battle.create! do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.matched_medal_infos.collect(&:key).collect(&:to_s).include?("居玉勝ちマン") }
      end
    end

    describe "アヒル上級" do
      before do
        Battle.create!(tactic_key:"アヒル囲い") do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.instance_eval(&MedalInfo["アヒル上級"].func) }
      end
    end

    describe "全チェック" do
      before do
        Battle.create! do |e|
          e.memberships.build(user: user)
        end
      end

      let :list do
        MedalInfo.find_all { |e| user.user_info.medal_list.instance_eval(&e.func) }
      end

      it do
        assert { list.collect(&:key) == [:居飛車党, :嬉野マン, :居玉勝ちマン] }
      end
    end
  end
end
