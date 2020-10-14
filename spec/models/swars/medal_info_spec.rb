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
          a.merge(k => v.user_info.medal_list.matched_medal_infos.collect(&:key).collect(&:to_s))
        }
      end

      def b(*tactic_keys)
        test(tactic_keys, :win)[:black]
      end

      def w(*tactic_keys)
        test(tactic_keys, :lose)[:white]
      end

      it do
        assert { b("角不成").include?("角不成マン")     }
        assert { b("飛車不成").include?("飛車不成マン") }

        # プレイヤー情報だけにあるもの
        assert { b("棒銀").include?("居飛車党")                   }
        assert { b("早石田").include?("振り飛車党")               }
        assert { b("棒銀", "早石田").include?("オールラウンダー") }
        assert { b("ロケット").include?("ロケットマン")           }
        assert { b("嬉野流").include?("嬉野マン")                 }
        assert { w("パックマン戦法").include?("パックマン野郎")   }
        assert { b("耀龍四間飛車").include?("耀龍マン")           }
        assert { b("耀龍ひねり飛車").include?("耀龍マン")         }
        assert { b("アヒル囲い").include?("アヒル上級")           }
        assert { b("UFO銀").include?("UFOマン")                   }
        assert { b("裏アヒル囲い").include?("レアマン")           }
        assert { b("カニカニ金").include?("カニ執着マン")         }
        assert { b("ダイヤモンド美濃").include?("ダイヤマン")     }
        assert { b("音無しの構え").include?("音無しマン")         }
        assert { b("筋違い角").include?("筋違い角おじさん")       }
        assert { b("いちご囲い").include?("スイーツマン")         }
        assert { b("背水の陣").include?("背水マン")               }
        assert { b("elmo囲い").include?("エルモマン")               }
        assert { b("レグスペ").include?("レグスペマン")           }
        assert { test(["無敵囲い"], :lose)[:white].include?("無敵囲いマン") }
        assert { test(["鬼殺し"], :win)[:white].include?("鬼殺されマン") }
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
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切断マン") }
      end
    end

    describe "居玉勝ちマン" do
      def csa_seq_generate(n)
        n.times.flat_map do |i|
          seconds = 600 - (i * 2.seconds)
          [["+2858HI", seconds], ["-5152OU", seconds], ["+5828HI", seconds], ["-5251OU", seconds]]
        end
      end

      before do
        Battle.create!(csa_seq: csa_seq_generate(20)) do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"居玉勝ちマン") }
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
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切れ負けマン") }
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
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"1手詰じらしマン") }
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
        assert { @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"絶対投了しないマン") }
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

        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
        assert { test(2.5).include?(:"長考マン")   }
        assert { test(2.5).exclude?(:"大長考マン") }
        assert { test(3.0).include?(:"大長考マン") }
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
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
        test(4).include?(:"ただの千日手")
        test(3).include?(:"開幕千日手")
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
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
        assert { test(20).include?(:"棋神マン") }
      end
    end

    describe "連勝" do
      def test(list)
        list.each do |win_or_lose|
          Battle.create! do |e|
            e.memberships.build(user: user, judge_key: win_or_lose)
          end
        end
        user.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
        assert { test(["win"] * 4).exclude?(:"5連勝") }

        assert { test(["win"]).include?(:"5連勝") }
        assert { test(["win"]).include?(:"5連勝") }
        assert { test(["win"]).include?(:"5連勝") }
        assert { test(["win"]).include?(:"8連勝") }
        assert { test(["win"]).include?(:"8連勝") }
        assert { test(["win"]).include?(:"8連勝") }
        assert { test(["win"]).include?(:"11連勝") }

        assert { test(["lose"] * 5).include?(:"波が激しいマン") }
      end
    end
  end
end
