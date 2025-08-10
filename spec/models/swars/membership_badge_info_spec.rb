require "rails_helper"

RSpec.describe Swars::MembershipBadgeInfo, type: :model, swars_spec: true do
  describe "タグ依存バッジ" do
    def case1(tactic_keys, win_or_lose)
      black = Swars::User.create!
      white = Swars::User.create!
      Array(tactic_keys).each do |e|
        Swars::Battle.create!(strike_plan: e) do |e|
          e.memberships.build(user: black, judge_key: win_or_lose)
          e.memberships.build(user: white)
        end
      end
      { black: black, white: white }.inject({}) { |a, (k, v)|
        a.merge(k => v.memberships.first.badge_info.key.to_s)
      }
    end

    it "works" do
      assert { case1("角不成", :win)[:black]   == "角不成マン"   }
      assert { case1("飛車不成", :win)[:black] == "飛車不成マン" }
      assert { case1("屍の舞", :win)[:black]   == "背水マン"     }
      assert { case1("入玉", :win)[:black]     == "入玉勝ちマン" }
    end
  end

  describe "切断マン" do
    def case1(n)
      @black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: :DISCONNECT) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
      end
      @black.memberships.first.badge_info.key == :"切断マン"
    end

    it "works" do
      assert { !case1(1) }
      assert { case1(2) }
    end
  end

  describe "絶対投了しないマン" do
    def case1(n)
      @black = Swars::User.create!
      @white = Swars::User.create!
      battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate(size: n, life_time: 60 * 10 - 1), final_key: :TIMEOUT) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
        e.memberships.build(user: @white, judge_key: :win)
      end
      battle.memberships.first.badge_key_with_messsage == [:"絶対投了しないマン", "悔しかったので時間切れになるまで9分59秒放置した"]
    end

    it "works" do
      assert { !case1(13) }
      assert { case1(14) }
    end
  end

  describe "相手退席待ちマン" do
    def case1
      @black = Swars::User.create!
      @white = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(16) + [["+5958OU", 300], ["-5152OU", 600], ["+5859OU", 1], ["-5251OU", 600]], final_key: :CHECKMATE) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
        e.memberships.build(user: @white, judge_key: :win)
      end
      @black.memberships.first.badge_info.key == :"相手退席待ちマン"
    end

    it "works" do
      assert { case1 }
    end
  end

  describe "1手詰焦らしマン" do
    def case1
      @black = Swars::User.create!
      @white = Swars::User.create!
      Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :CHECKMATE) do |e|
        e.memberships.build(user: @black, judge_key: :win)
        e.memberships.build(user: @white, judge_key: :lose)
      end
      @black.memberships.first.badge_key_with_messsage == [:"1手詰焦らしマン", "1手詰を9分58秒焦らして歪んだ優越感に浸った"]
    end

    it "works" do
      assert { case1 }
    end
  end

  describe "必勝形焦らしマン" do
    def case1
      @black = Swars::User.create!
      @white = Swars::User.create!
      Swars::Battle.create!(csa_seq: [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 1]], final_key: :TIMEOUT) do |e|
        e.memberships.build(user: @black, judge_key: :win)
        e.memberships.build(user: @white, judge_key: :lose)
      end
      @black.memberships.first.badge_key_with_messsage == [:"必勝形焦らしマン", "必勝形から9分58秒焦らして歪んだ優越感に浸った"]
    end

    it "works" do
      assert { case1 }
    end
  end

  describe "長考" do
    def test(min, judge_key)
      seconds = min.minutes

      @black = Swars::User.create!
      @white = Swars::User.create!
      Swars::Battle.create!(csa_seq: [["+7968GI", 600 - seconds], ["-8232HI", 597], ["+5756FU", 600 - seconds - 1]], final_key: :CHECKMATE) do |e|
        e.memberships.build(user: @black, judge_key: judge_key)
        e.memberships.build(user: @white)
      end
      @black.memberships.first.badge_key_with_messsage
    end

    it "works" do
      assert { test(2.5, :lose) == [:長考マン, "考えすぎて負けた。ちなみにいちばん長かったのは2分30秒"] }
      assert { test(3.0, :win)  == [:大長考マン, "対局放棄と受け取られかねない3分の長考をした"] }
      assert { test(3.0, :lose) == [:大長考負けマン, "対局放棄と受け取られかねない3分の長考をしたあげく負けた"] }
    end
  end

  describe "棋力調整マン" do
    def case1(n, final_key)
      black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: final_key) do |e|
        e.memberships.build(user: black, judge_key: :lose)
      end
      black.memberships.first.badge_info.key == :"棋力調整マン"
    end

    it "works" do
      assert { case1(13, :TORYO) == true  }
      assert { case1(14, :TORYO) == false }
    end
  end

  describe "無気力マン" do
    def case1(n, final_key)
      black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: final_key) do |e|
        e.memberships.build(user: black, judge_key: :lose)
      end
      black.memberships.first.badge_info.key == :"無気力マン"
    end

    it "works" do
      assert { case1(13, :TORYO) == false }
      assert { case1(14, :TORYO) == true  }
      assert { case1(44, :TORYO) == true  }
      assert { case1(45, :TORYO) == false }
    end
  end

  describe "開幕千日手" do
    def case1(n)
      @black = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: :DRAW_SENNICHI) do |e|
        e.memberships.build(user: @black, judge_key: :draw)
      end
      @black.memberships.first.badge_info.key
    end

    it "works" do
      assert { case1(12) == :"開幕千日手"   }
    end
  end

  describe "ただの千日手" do
    def case1(n)
      @black = Swars::User.create!
      @white = Swars::User.create!
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(n), final_key: :DRAW_SENNICHI) do |e|
        e.memberships.build(user: @black, judge_key: :draw)
        e.memberships.build(user: @white, judge_key: :draw)
      end
      @white.memberships.first.badge_info.key
    end

    it "works" do
      assert { case1(13) == :"ただの千日手" }
    end
  end

  describe "切れ負けマン" do
    def case1(final_key)
      @black = Swars::User.create!
      @white = Swars::User.create!
      battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.kiremake, final_key: final_key) do |e|
        e.memberships.build(user: @black, judge_key: :lose)
        e.memberships.build(user: @white, judge_key: :win)
      end
      @black.memberships.first.badge_info.key == :"切れ負けマン"
    end

    it "works" do
      assert { !case1(:TORYO) }
      assert { case1(:TIMEOUT) }
    end
  end

  describe "運営支えマン" do
    def test(pattern)
      @black = Swars::User.create!
      @white = Swars::User.create!
      battle = Swars::Battle.create!(csa_seq: Swars::KifuGenerator.send(pattern), final_key: :CHECKMATE) do |e|
        e.memberships.build(user: @black, judge_key: :win)
        e.memberships.build(user: @white, judge_key: :lose)
      end
      battle.memberships[0].badge_info.key
    end

    it "works" do
      assert { test(:fraud_pattern) == :"運営支えマン" }
      assert { test(:no_fraud_pattern) != :"運営支えマン" }
    end
  end

  describe "段級差" do
    def case1(*keys)
      Swars::Battle.create!(csa_seq: Swars::KifuGenerator.generate_n(45)) { |e|
        keys.each do |key|
          e.memberships.build(user: Swars::User.create!(grade_key: key))
        end
      }.memberships.collect { |e| e.badge_params[:message] }
    end

    it "全パターン" do
      case1("30級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"]
      case1("12級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"]
      case1("11級", "1級") # => ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"]
      case1("10級", "1級") # => ["9つも格上の人を倒した", "9つも格下の人に勝って当然なのに負けた"]
      case1("9級",  "1級") # => ["8つも格上の人を倒した", "8つも格下の人に勝って当然なのに負けた"]
      case1("8級",  "1級") # => ["7つも格上の人を倒した", "7つも格下の人に勝って当然なのに負けた"]
      case1("7級",  "1級") # => ["6つも格上の人を倒した", "6つも格下の人に勝って当然なのに負けた"]
      case1("6級",  "1級") # => ["5つも格上の人を倒した", "5つも格下の人に勝って当然なのに負けた"]
      case1("5級",  "1級") # => ["4つも格上の人を倒した", "4つも格下の人に勝って当然なのに負けた"]
      case1("4級",  "1級") # => ["3つも格上の人を倒した", "3つも格下の人に勝って当然なのに負けた"]
      case1("3級",  "1級") # => ["2つも格上の人を倒した", "2つも格下の人に勝って当然なのに負けた"]
      case1("2級",  "1級") # => ["格上のライバルを倒した", "1つ格下の人に負けた"]
      case1("1級",  "1級") # => ["同じ棋力のライバルに勝った", "同じ棋力のライバルに負けた"]
      case1("初段", "1級") # => ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"]
      case1("二段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("三段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("四段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("五段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("六段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("七段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("八段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("九段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]
      case1("十段", "1級") # => ["格下の人に当然のように勝った", "格上の人に当然のように負けた"]

      assert {  case1("30級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"] }
      assert {  case1("12級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"] }
      assert {  case1("11級", "1級") == ["恐怖の級位者として無双した", "達成率をがっつり奪われた(ように感じるが実際はそんな減ってない)"] }
      assert {  case1("10級", "1級") == ["9つも格上の人を倒した", "9つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("9級",  "1級") == ["8つも格上の人を倒した", "8つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("8級",  "1級") == ["7つも格上の人を倒した", "7つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("7級",  "1級") == ["6つも格上の人を倒した", "6つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("6級",  "1級") == ["5つも格上の人を倒した", "5つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("5級",  "1級") == ["4つも格上の人を倒した", "4つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("4級",  "1級") == ["3つも格上の人を倒した", "3つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("3級",  "1級") == ["2つも格上の人を倒した", "2つも格下の人に勝って当然なのに負けた"] }
      assert {  case1("2級",  "1級") == ["格上のライバルを倒した", "1つ格下の人に負けた"] }
      assert {  case1("1級",  "1級") == ["同じ棋力のライバルに勝った", "同じ棋力のライバルに負けた"] }
      assert {  case1("初段", "1級") == ["格下の人に着実に勝った", "格上のライバルにやっぱり負けた"] }
      assert {  case1("二段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("三段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("四段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("五段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("六段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("七段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("八段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("九段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
      assert {  case1("十段", "1級") == ["格下の人に当然のように勝った", "格上の人に当然のように負けた"] }
    end
  end
end
# >> Swars::Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::MembershipBadgeInfo
# >>   タグ依存バッジ
# >>     works
# >>   切断マン
# >>     works
# >>   絶対投了しないマン
# >>     works
# >>   相手退席待ちマン
# >>     works
# >>   1手詰焦らしマン
# >>     works
# >>   長考
# >>     works
# >>   無気力マン
# >>     works
# >>   ただの千日手
# >>     works
# >>   切れ負けマン
# >>     works
# >>   運営支えマン
# >>     works
# >>   段級差
# >>     全パターン
# >>
# >> Swars::Top 5 slowest examples (8.38 seconds, 67.1% of total time):
# >>   Swars::MembershipBadgeInfo 段級差 全パターン
# >>     4.73 seconds -:208
# >>   Swars::MembershipBadgeInfo タグ依存バッジ works
# >>     1.7 seconds -:28
# >>   Swars::MembershipBadgeInfo 無気力マン works
# >>     0.97467 seconds -:135
# >>   Swars::MembershipBadgeInfo 長考 works
# >>     0.48728 seconds -:117
# >>   Swars::MembershipBadgeInfo 絶対投了しないマン works
# >>     0.47456 seconds -:64
# >>
# >> Swars::Finished in 12.48 seconds (files took 2.96 seconds to load)
# >> 11 examples, 0 failures
# >>
