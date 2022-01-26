require "rails_helper"

module Swars
  RSpec.describe type: :model, swars_spec: true do
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

      it "works" do
        assert { b("角不成").include?("角不成マン")     }
        assert { b("飛車不成").include?("飛車不成マン") }
        # プレイヤー情報だけにあるもの
        assert { b("棒銀").include?("居飛車党")                             }
        assert { b("早石田").include?("振り飛車党")                         }
        assert { b("棒銀", "早石田").include?("オールラウンダー")           }
        assert { b("ロケット").include?("ロケットマン")                     }
        assert { b("遠見の角").include?("遠見の角マン")                     }
        assert { b("嬉野流").include?("嬉野マン")                           }
        assert { w("パックマン戦法").include?("パックマン野郎")             }
        assert { b("耀龍四間飛車").include?("耀龍マン")                     }
        assert { b("耀龍ひねり飛車").include?("耀龍マン")                   }
        assert { w("右玉").include?("右玉マン")                             }
        assert { b("糸谷流右玉").include?("右玉マン")                       }
        assert { w("羽生流右玉").include?("右玉マン")                       }
        assert { b("アヒル囲い").include?("アヒル上級")                     }
        assert { b("UFO銀").include?("UFOマン")                             }
        assert { b("裏アヒル囲い").include?("レアマン")                     }
        assert { b("カニカニ金").include?("カニ執着マン")                   }
        assert { b("カメレオン戦法").include?("カメレオンマン")             }
        assert { w("ポンポン桂").include?("ポンポンマン")                   }
        assert { w("右四間飛車左美濃").include?("右四間飛車マン")           }
        assert { b("ダイヤモンド美濃").include?("ダイヤマン")               }
        assert { b("チョコレート囲い").include?("チョコレートマン")         }
        assert { b("極限早繰り銀").include?("極限早繰りマン")               }
        assert { b("坊主美濃").include?("坊主マン")                         }
        assert { b("ツノ銀中飛車").include?("中飛車マン")                   }
        assert { b("居飛穴音無しの構え").include?("音無しマン")             }
        assert { b("筋違い角").include?("筋違い角おじさん")                 }
        assert { b("いちご囲い").include?("スイーツマン")                   }
        assert { b("背水の陣").include?("背水マン")                         }
        assert { b("エルモ囲い").include?("エルモマン")                     }
        assert { w("銀冠の小部屋").include?("小部屋マン")                   }
        assert { w("レグスペ").include?("レグスペマン")                     }
        assert { b("入玉").include?("入玉勝ちマン")                         }
        assert { test(["無敵囲い"], :lose)[:white].include?("無敵囲いマン") }
        assert { test(["鬼殺し"], :win)[:white].include?("鬼殺されマン")    }
      end
    end

    describe "切断マン" do
      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :DISCONNECT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切断マン")
      end

      it do
        assert { test1(13) == false }
        assert { test1(14) == true  }
      end
    end

    describe "居玉勝ちマン" do
      before do
        Battle.create!(csa_seq: csa_seq_generate6(50)) do |e|
          e.memberships.build(user: user)
        end
      end

      it do
        assert { user.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"居玉勝ちマン") }
      end
    end

    describe "切れ負けマン" do
      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"切れ負けマン")
      end

      it do
        assert { test1(13) == false }
        assert { test1(14) == true  }
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

    describe "相手退席待ちマン" do
      def test1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(16) + [["+5958OU", 300], ["-5152OU", 600], ["+5859OU", 1], ["-5251OU", 600]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it "works" do
        assert { test1.include?(:"相手退席待ちマン") }
      end
    end

    describe "絶対投了しないマン" do
      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key).include?(:"絶対投了しないマン")
      end

      it "works" do
        assert { !test1(13) }
        assert { test1(14) }
        assert { test1(15) }
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
      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: :DRAW_SENNICHI) do |e|
          e.memberships.build(user: @black, judge_key: :draw)
          e.memberships.build(user: @white, judge_key: :draw)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
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

      it do
        assert { test(20).include?(:"運営支えマン") }
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

        assert { test(["win"]).include?(:"5連勝")  }
        assert { test(["win"]).include?(:"6連勝")  }
        assert { test(["win"]).include?(:"7連勝")  }
        assert { test(["win"]).include?(:"8連勝")  }
        assert { test(["win"]).include?(:"9連勝")  }
        assert { test(["win"]).include?(:"10連勝") }
        assert { test(["win"]).include?(:"11連勝") }

        assert { test(["lose"] * 5).include?(:"波が激しいマン") }
      end
    end

    describe "無気力マン" do
      def test1(n, final_key)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n), final_key: final_key) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_info.medal_list.matched_medal_infos.collect(&:key)
      end

      it do
        result = [:"居飛車党", :"無気力マン"]
        assert { test1(19, :TORYO) == result }
        assert { test1(19, :CHECKMATE) == result }
        assert { test1(20, :CHECKMATE) != result }
        assert { test1(19, :TIMEOUT) != result }
        assert { test1(20, :TIMEOUT) != result }
      end
    end

  end
end
