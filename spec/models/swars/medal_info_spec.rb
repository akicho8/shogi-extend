require "rails_helper"

module Swars
  RSpec.describe type: :model, swars_spec: true do
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

      it "works" do
        assert2 { b("角不成").include?("角不成マン")     }
        assert2 { b("飛車不成").include?("飛車不成マン") }
        # プレイヤー情報だけにあるもの
        assert2 { b("棒銀").include?("居飛車党")                             }
        assert2 { b("早石田").include?("振り飛車党")                         }
        assert2 { b("棒銀", "早石田").include?("オールラウンダー")           }
        assert2 { b("ロケット").include?("ロケットマン")                     }
        assert2 { b("遠見の角").include?("遠見の角マン")                     }
        assert2 { b("屋敷流二枚銀").include?("屋敷マン")                     }
        assert2 { b("屋敷流二枚銀棒銀型").include?("屋敷マン")               }
        assert2 { b("嬉野流").include?("嬉野マン")                           }
        assert2 { w("パックマン戦法").include?("パックマン野郎")             }
        assert2 { b("耀龍四間飛車").include?("耀龍マン")                     }
        assert2 { b("耀龍ひねり飛車").include?("耀龍マン")                   }
        assert2 { w("右玉").include?("右玉マン")                             }
        assert2 { b("糸谷流右玉").include?("右玉マン")                       }
        assert2 { w("羽生流右玉").include?("右玉マン")                       }
        assert2 { b("アヒル囲い").include?("アヒル上級")                     }
        assert2 { b("UFO銀").include?("UFOマン")                             }
        assert2 { b("裏アヒル囲い").include?("レア戦法マン")                 }
        assert2 { b("カニカニ金").include?("カニ執着マン")                   }
        assert2 { b("一間飛車").include?("一間飛車マン")                     }
        assert2 { b("一間飛車穴熊").include?("一間飛車マン")                 }
        assert2 { b("カメレオン戦法").include?("カメレオンマン")             }
        assert2 { w("ポンポン桂").include?("ポンポンマン")                   }
        assert2 { w("右四間飛車左美濃").include?("右四間飛車マン")           }
        assert2 { b("ダイヤモンド美濃").include?("ダイヤマン")               }
        assert2 { b("チョコレート囲い").include?("チョコレートマン")         }
        assert2 { b("幽霊角").include?("幽霊角マン")                         }
        assert2 { b("極限早繰り銀").include?("極限早繰りマン")               }
        assert2 { b("坊主美濃").include?("坊主マン")                         }
        assert2 { b("袖飛車").include?("袖飛車マン")                         }
        assert2 { b("ツノ銀中飛車").include?("中飛車マン")                   }
        assert2 { b("居飛穴音無しの構え").include?("音無しマン")             }
        assert2 { b("筋違い角").include?("筋違い角おじさん")                 }
        assert2 { b("いちご囲い").include?("スイーツマン")                   }
        assert2 { b("背水の陣").include?("背水マン")                         }
        assert2 { b("エルモ囲い").include?("エルモマン")                     }
        assert2 { w("銀冠の小部屋").include?("小部屋マン")                   }
        assert2 { w("レグスペ").include?("レグスペマン")                     }
        assert2 { b("入玉").include?("入玉勝ちマン")                         }
        assert2 { test(["無敵囲い"], :lose)[:white].include?("無敵囲いマン") }
        assert2 { test(["鬼殺し"], :win)[:white].include?("鬼殺されマン")    }
      end
    end

    describe "切断マン" do
      def case1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切断マン")
      end

      it "works" do
        assert2 { case1(13) == false }
        assert2 { case1(14) == true  }
      end
    end

    describe "居玉勝ちマン" do
      before do
        Battle.create!(csa_seq: csa_seq_generate6(50)) do |e|
          e.memberships.build(user: user)
        end
      end

      it "works" do
        assert2 { user.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"居玉勝ちマン") }
      end
    end

    describe "切れ負けマン" do
      def case1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切れ負けマン")
      end

      it "works" do
        assert2 { case1(13) == false }
        assert2 { case1(14) == true  }
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

      it "works" do
        assert2 { @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"1手詰じらしマン") }
      end
    end

    describe "相手退席待ちマン" do
      def case1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(16) + [["+5958OU", 300], ["-5152OU", 600], ["+5859OU", 1], ["-5251OU", 600]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "works" do
        assert2 { case1.include?(:"相手退席待ちマン") }
      end
    end

    describe "絶対投了しないマン" do
      def case1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"絶対投了しないマン")
      end

      it "works" do
        assert2 { !case1(13) }
        assert2 { case1(14) }
        assert2 { case1(15) }
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

      it "works" do
        assert2 { test(2.5).include?(:"長考マン")   }
        assert2 { test(2.5).exclude?(:"大長考マン") }
        assert2 { test(3.0).include?(:"大長考マン") }
      end
    end

    describe "ただの千日手" do
      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :DRAW_SENNICHI) do |e|
          e.memberships.build(user: @black, judge_key: :draw)
          e.memberships.build(user: @white, judge_key: :draw)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "works" do
        test(16).include?(:"ただの千日手")
        test(12).include?(:"開幕千日手")
      end
    end

    describe "運営支えマン" do
      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate4(n), final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "works" do
        assert2 { test(20).include?(:"運営支えマン") }
      end
    end

    describe "無気力マン" do
      def case1(n, final_key)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "works" do
        result = [:"居飛車党", :"無気力マン"]
        assert2 { case1(19, :TORYO) == result }
        assert2 { case1(19, :CHECKMATE) == result }
        assert2 { case1(20, :CHECKMATE) != result }
        assert2 { case1(19, :TIMEOUT) != result }
        assert2 { case1(20, :TIMEOUT) != result }
      end
    end

    describe "対局モード" do
      def case1(xmode)
        xmode = Xmode.fetch(xmode)
        @black = User.create!
        @white = User.create!
        Battle.create_with_members!([@black, @white], xmode: xmode)
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "友対マン" do
        assert2 { case1("友達").include?(:"友対マン") }
      end

      it "指導受けマン" do
        assert2 { case1("指導").include?(:"指導受けマン") }
      end
    end
  end
end
