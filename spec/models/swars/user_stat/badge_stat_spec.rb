require "rails_helper"
require "#{__dir__}/badge_stat_or_condition_only_tag_badge_test_case_list"

module Swars
  RSpec.describe UserStat::BadgeStat, type: :model, swars_spec: true do
    it "対局が0件の場合でもエラーにならない" do
      user = User.create!
      assert { user.user_stat.badge_stat.as_json }
    end

    # 判定できるのは OR 条件のタグのみ。
    # つまりオールラウンダーはこれで判定してはいけない。
    # 「早石田」で後手が勝つ場合、先手の win_tag に「早石田」は入らないので「三間飛車で勝った」のテストができない。
    # したがって早石田を持っている側を勝ちにする。
    # こうすることでテストしたいタグを持っている側の win_tag に必ず該当のタグが入る。
    describe "OR判定専用タグ依存メダル" do
      def case1(e)
        black = User.create!
        white = User.create!
        skill = Bioshogi::Explain::TacticInfo.flat_lookup(e[:tactic_key])
        info = skill.sample_kif_info
        player = info.container.players.find { |e| e.skill_set.has_skill?(skill) } # このスキルを持っているプレイヤー
        Battle.create!(tactic_key: e[:tactic_key]) do |e|
          e.memberships.build(user: black, judge_key: player.location.key == :black ? :win : :lose) # そのプレイヤーの方を勝ちにする
          e.memberships.build(user: white, judge_key: player.location.key == :white ? :win : :lose)
        end
        [black, white].any? do |user|
          if false
            p user.user_stat.win_tag.to_s
            p user.user_stat.instance_eval(&UserStat::BadgeInfo.fetch(e[:expected_badge_key]).if_cond)
          end
          user.user_stat.badge_stat.active?(e[:expected_badge_key])
        end
      end

      BadgeStatOrConditionOnlyTagBadgeTestCaseList.each do |e|
        it "#{e[:tactic_key]} → #{e[:expected_badge_key]}" do
          assert { case1(e) }
        end
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
        assert { @black.user_stat.badge_stat.active?(:"1手詰じらしマン") }
      end
    end

    describe "絶対投了しないマン" do
      def case1
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(final_key: :TIMEOUT) do |e|
          e.memberships.build(user: @black, judge_key: :lose)
          e.memberships.build(user: @white, judge_key: :win)
        end
        @black.user_stat.badge_stat.active?(:"絶対投了しないマン")
      end

      it "works" do
        assert { case1 }
      end
    end

    describe "ただの千日手" do
      def test(n)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: KifuGenerator.generate_n(n), final_key: :DRAW_SENNICHI) do |e|
          e.memberships.build(user: @black, judge_key: :draw)
          e.memberships.build(user: @white, judge_key: :draw)
        end
        @black.user_stat.badge_stat.active_badges.collect(&:key)
      end

      it "works" do
        test(16).include?(:"ただの千日手")
        test(12).include?(:"開幕千日手")
      end
    end

    describe "運営支えマン" do
      def test(pattern)
        @black = User.create!
        @white = User.create!
        Swars::Battle.create!(csa_seq: KifuGenerator.send(pattern), final_key: :CHECKMATE) do |e|
          e.memberships.build(user: @black, judge_key: :win)
          e.memberships.build(user: @white, judge_key: :lose)
        end
        @black.user_stat.badge_stat.active_badges.collect(&:key)
      end

      it "works" do
        assert { test(:fraud_pattern).include?(:"運営支えマン") }
        assert { test(:no_fraud_pattern).exclude?(:"運営支えマン") }
      end
    end
  end
end
