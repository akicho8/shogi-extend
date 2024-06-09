require "rails_helper"
require "#{__dir__}/badge_stat_or_condition_only_tag_badge_test_case_list"

module Swars
  RSpec.describe User::Stat::BadgeStat, type: :model, swars_spec: true do
    describe "バッジ" do
      # 判定できるのは OR 条件のタグのみ。
      # つまりオールラウンダーはこれで判定してはいけない。
      # 「早石田」で後手が勝つ場合、先手の win_tag に「早石田」は入らないので「三間飛車で勝った」のテストができない。
      # したがって早石田を持っている側を勝ちにする。
      # こうすることでテストしたいタグを持っている側の win_tag に必ず該当のタグが入る。
      describe "OR判定専用タグ依存バッジ" do
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
              p user.stat.win_stat.to_s
              p user.stat.instance_eval(&User::Stat::BadgeInfo.fetch(e[:expected_badge_key]).if_cond)
            end
            user.stat.badge_stat.active?(e[:expected_badge_key])
          end
        end

        BadgeStatOrConditionOnlyTagBadgeTestCaseList.each do |e|
          it "#{e[:tactic_key]} → #{e[:expected_badge_key]}" do
            assert { case1(e) }
          end
        end
      end

      it "対局が0件の場合でもエラーにならない" do
        user = User.create!
        assert { user.stat.badge_stat.as_json }
      end
    end
  end
end
