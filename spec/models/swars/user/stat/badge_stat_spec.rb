require "rails_helper"
require "#{__dir__}/badge_stat_or_condition_only_tag_badge_test_case_list"

RSpec.describe Swars::User::Stat::BadgeStat, type: :model, swars_spec: true do
  describe "バッジ" do
    # 判定できるのは OR 条件のタグのみ。
    # つまりオールラウンダーはこれで判定してはいけない。
    # 「早石田」で後手が勝つ場合、先手の win_tag に「早石田」は入らないので「三間飛車で勝った」のテストができない。
    # したがって早石田を持っている側を勝ちにする。
    # こうすることでテストしたいタグを持っている側の win_tag に必ず該当のタグが入る。
    describe "OR判定専用タグ依存バッジ" do
      def case1(e)
        black = Swars::User.create!
        white = Swars::User.create!
        skill = Bioshogi::Analysis::TagIndex.lookup(e[:strike_plan])
        info = skill.static_kif_info
        player = info.container.players.find { |e| e.tag_bundle.include?(skill) } # このスキルを持っているプレイヤー
        e[:n_times].times do
          Swars::Battle.create!(strike_plan: e[:strike_plan]) do |e|
            e.memberships.build(user: black, judge_key: player.location.key == :black ? :win : :lose) # そのプレイヤーの方を勝ちにする
            e.memberships.build(user: white, judge_key: player.location.key == :white ? :win : :lose)
          end
        end
        [black, white].any? do |user|
          if false
            p user.stat.win_stat.to_s
            p user.stat.instance_eval(&Swars::User::Stat::BadgeInfo.fetch(e[:expected_badge_key]).if_cond)
          end
          user.stat.badge_stat.active?(e[:expected_badge_key])
        end
      end

      BadgeStatOrConditionOnlyTagBadgeTestCaseList.each do |e|
        it "#{e[:strike_plan]} → #{e[:expected_badge_key]}" do
          assert { case1(e) }
        end
      end

      it "入玉" do
        e = { expected_badge_key: "入玉勝ちマン", strike_plan: "入玉", n_times: 1 }
        assert { case1(e) }
      end
    end

    it "対局が0件の場合でもエラーにならない" do
      user = Swars::User.create!
      assert { user.stat.badge_stat.as_json }
    end
  end
end
