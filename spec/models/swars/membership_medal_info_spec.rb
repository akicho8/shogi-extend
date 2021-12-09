require "rails_helper"

module Swars
  RSpec.describe MembershipMedalInfo, type: :model, swars_spec: true do
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
        assert { b("入玉")     == "入玉勝ちマン" }
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
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        assert { test1(13) != [:切断マン, "悔しかったので切断した"] }
        assert { test1(14) == [:切断マン, "悔しかったので切断した"] }
      end
    end

    describe "絶対投了しないマン" do
      def test1(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate1(n, sec: 1), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message == [:絶対投了しないマン, "悔しかったので時間切れになるまで9分59秒放置した"]
      end

      it do
        assert { !test1(13) }
        assert { test1(14) }
        assert { test1(15) }
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
        @black.memberships.first.first_matched_medal_key_and_message.first
      end

      it do
        assert { test1 == :"相手退席待ちマン" }
      end
    end

    describe "1手詰じらしマン" do
      def test1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test1                   # => [:"1手詰じらしマン", "1手詰を9分58秒焦らして歪んだ優越感に浸った"]
        assert { test1 == [:"1手詰じらしマン", "1手詰を9分58秒焦らして歪んだ優越感に浸った"] }
      end
    end

    describe "長考" do
      def test(min, judge_key)
        seconds = min.minutes

        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]], final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: judge_key)
          e.memberships.build(user: @white)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        assert { test(2.5, :lose) == [:長考マン, "考えすぎて負けた。ちなみに一番長かったのは2分30秒"] }
        assert { test(3.0, :win)  == [:大長考マン, "対局放棄と受け取られかねない3分の長考をした"] }
        assert { test(3.0, :lose) == [:大長考負けマン, "対局放棄と受け取られかねない3分の長考をしたあげく負けた"] }
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
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        result = [:"無気力マン", "無気力対局"]
        assert { test1(19, :TORYO)     == result }
        assert { test1(20, :TORYO)     != result }
        assert { test1(19, :CHECKMATE) == result }
        assert { test1(20, :CHECKMATE) != result }
        assert { test1(19, :TIMEOUT)   != result }
        assert { test1(20, :TIMEOUT)   != result }
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
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test(4*4)                 # => [:ただの千日手, "千日手"]
        test(3*4)                 # => [:開幕千日手, "最初から千日手にした"]
        assert { test(4*4) == [:ただの千日手, "千日手"]             }
        assert { test(3*4) == [:開幕千日手, "最初から千日手にした"] }
      end
    end

    describe "切れ負けマン" do
      def test1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: csa_seq_generate3(20, 30), final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test1                   # => [:切れ負けマン, "時間切れで負けた"]
        assert { test1 == [:切れ負けマン, "時間切れで負けた"] }
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
        @black.memberships.first.first_matched_medal_key_and_message
      end

      it do
        test(20)                # => [:運営支えマン, "将棋ウォーズの運営を支える力がある"]
        assert { test(20) == [:運営支えマン, "将棋ウォーズの運営を支える力がある"] }
      end
    end

    describe "段級差" do
      def test1(*keys)
        Battle.create!(csa_seq: csa_seq_generate1(20)) { |e|
          keys.each do |key|
            e.memberships.build(user: User.create!(grade_key: key))
          end
        }.memberships.collect { |e| e.medal_params[:message] }
      end

      it "全パターン" do
        test1("30級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("12級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("11級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた"]
        test1("10級", "1級") # => ["9つも格上の人を倒した", "9つも格下の人に勝って当然なのに負けた"]
        test1( "9級", "1級") # => ["8つも格上の人を倒した", "8つも格下の人に勝って当然なのに負けた"]
        test1( "8級", "1級") # => ["7つも格上の人を倒した", "7つも格下の人に勝って当然なのに負けた"]
        test1( "7級", "1級") # => ["6つも格上の人を倒した", "6つも格下の人に勝って当然なのに負けた"]
        test1( "6級", "1級") # => ["5つも格上の人を倒した", "5つも格下の人に勝って当然なのに負けた"]
        test1( "5級", "1級") # => ["4つも格上の人を倒した", "4つも格下の人に勝って当然なのに負けた"]
        test1( "4級", "1級") # => ["3つも格上の人を倒した", "3つも格下の人に勝って当然なのに負けた"]
        test1( "3級", "1級") # => ["2つも格上の人を倒した", "2つも格下の人に勝って当然なのに負けた"]
        test1( "2級", "1級") # => ["格上のライバルを倒した", "1つ格下の人に負けた"]
        test1( "1級", "1級") # => ["同じ棋力のライバルに勝った", "同じ棋力のライバルに負けた"]
        test1("初段", "1級") # => ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"]
        test1("二段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("三段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("四段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("五段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("六段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("七段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("八段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("九段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
        test1("十段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]

        assert {  test1("30級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("12級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("11級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた"] }
        assert {  test1("10級", "1級") == ["9つも格上の人を倒した", "9つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "9級", "1級") == ["8つも格上の人を倒した", "8つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "8級", "1級") == ["7つも格上の人を倒した", "7つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "7級", "1級") == ["6つも格上の人を倒した", "6つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "6級", "1級") == ["5つも格上の人を倒した", "5つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "5級", "1級") == ["4つも格上の人を倒した", "4つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "4級", "1級") == ["3つも格上の人を倒した", "3つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "3級", "1級") == ["2つも格上の人を倒した", "2つも格下の人に勝って当然なのに負けた"] }
        assert {  test1( "2級", "1級") == ["格上のライバルを倒した", "1つ格下の人に負けた"] }
        assert {  test1( "1級", "1級") == ["同じ棋力のライバルに勝った", "同じ棋力のライバルに負けた"] }
        assert {  test1("初段", "1級") == ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"] }
        assert {  test1("二段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("三段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("四段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("五段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("六段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("七段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("八段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("九段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
        assert {  test1("十段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..........
# >>
# >> Finished in 14.56 seconds (files took 4.85 seconds to load)
# >> 10 examples, 0 failures
# >>
