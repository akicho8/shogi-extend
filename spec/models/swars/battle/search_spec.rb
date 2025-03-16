require "rails_helper"

RSpec.describe Swars::Battle::Search, type: :model, swars_spec: true do
  it "データが空の場合" do
    assert { Swars::Battle.find_all_by_query.count == 0 }
  end

  it "絞り込まない場合は全件引く" do
    Swars::Battle.create!
    assert { Swars::Battle.find_all_by_query.count == 1 }
  end

  describe "基本" do
    it "id" do
      ids = 2.times.collect { Swars::Battle.create!.id }.join(",")
      assert { Swars::Battle.find_all_by_query("id:#{ids}").count == 2 }
    end

    it "key" do
      keys = 2.times.collect { Swars::Battle.create!.key }.join(",")
      assert { Swars::Battle.find_all_by_query("key:#{keys}").count == 2 }
    end
  end

  describe "Battleに入っているその他のカラム" do
    it "battled_at" do
      Swars::Battle.create!
      assert { Swars::Battle.find_all_by_query("date:2000").count       == 1 }
      assert { Swars::Battle.find_all_by_query("date:2000-01").count    == 1 }
      assert { Swars::Battle.find_all_by_query("date:2000-01-01").count == 1 }
      assert { Swars::Battle.find_all_by_query("date:1999").count       == 0 }
    end
  end

  describe "Battleに入っている整数カラム" do
    it "critical_turn" do
      battle = Swars::Battle.create!.tap { |e| e.update!(critical_turn: 5) }
      assert { Swars::Battle.find_all_by_query("critical_turn:==5").count == 1 }
      assert { Swars::Battle.find_all_by_query("critical_turn:!=5").count == 0 }
    end

    it "outbreak_turn" do
      battle = Swars::Battle.create!.tap { |e| e.update!(outbreak_turn: 5) }
      assert { Swars::Battle.find_all_by_query("outbreak_turn:==5").count == 1 }
      assert { Swars::Battle.find_all_by_query("outbreak_turn:!=5").count == 0 }
    end

    it "turn_max" do
      battle = Swars::Battle.create!.tap { |e| e.update!(turn_max: 5) }
      assert { Swars::Battle.find_all_by_query("turn_max:==5").count == 1 }
      assert { Swars::Battle.find_all_by_query("turn_max:!=5").count == 0 }
    end
  end

  describe "外部テーブルを見る必要があるカラムたち" do
    it "xmode" do
      Swars::XmodeInfo.each { |e| Swars::Battle.create!(xmode_key: e.key) }
      assert { Swars::Battle.find_all_by_query("xmode:野良,友達").count == 2 }
    end

    it "imode" do
      Swars::ImodeInfo.each { |e| Swars::Battle.create!(imode_key: e.key) }
      assert { Swars::Battle.find_all_by_query("imode:スプリント").count == 1 }
    end

    it "rule" do
      Swars::RuleInfo.each { |e| Swars::Battle.create!(rule_key: e.key) }
      assert { Swars::Battle.find_all_by_query("rule:10分,3分").count == 2 }
    end

    it "final" do
      Swars::FinalInfo.each { |e| Swars::Battle.create!(final_key: e.key) }
      assert { Swars::Battle.find_all_by_query("final:投了,時間切れ").count == 2 }
    end

    it "preset" do
      PresetInfo.each { |e| Swars::Battle.create!.update!(preset_key: e.key) }
      assert { Swars::Battle.find_all_by_query("preset:平手,角落ち").count == 2 }
    end
  end

  describe "Membershipを見る" do
    it "judge" do
      battle = Swars::Battle.create!
      assert { Swars::Battle.find_all_by_query("勝敗:勝ち", target_owner: battle.memberships.black.user).count == 1 }
      assert { Swars::Battle.find_all_by_query("勝敗:負け", target_owner: battle.memberships.black.user).count == 0 }
    end

    it "location" do
      battle = Swars::Battle.create!
      assert { Swars::Battle.find_all_by_query("先後:▲", target_owner: battle.memberships.black.user).count == 1 }
      assert { Swars::Battle.find_all_by_query("先後:△", target_owner: battle.memberships.black.user).count == 0 }
    end

    it "垢BAN" do
      battle = Swars::Battle.create!.tap { |e| e.memberships.white.user.ban! }
      assert { Swars::Battle.find_all_by_query("垢BAN:絞る", target_owner: battle.memberships.black.user).count == 1 }
      assert { Swars::Battle.find_all_by_query("垢BAN:除外", target_owner: battle.memberships.black.user).count == 0 }
    end

    it "対戦相手" do
      battle = Swars::Battle.create!
      white = battle.memberships.white.user.key
      assert { Swars::Battle.find_all_by_query("vs:#{white}", target_owner: battle.memberships.black.user).count == 1 }
      assert { Swars::Battle.find_all_by_query("vs:xxxxxxxx", target_owner: battle.memberships.black.user).count == 0 }
    end

    describe "棋風" do
      def case1
        Swars::Battle.create!.tap do |e|
          e.memberships.black.update!(style_key: "変態")
          e.memberships.white.update!(style_key: "王道")
        end
      end

      it "style" do
        battle = case1
        assert { Swars::Battle.find_all_by_query("自分の棋風:変態", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("自分の棋風:王道", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "vs-style" do
        battle = case1
        assert { Swars::Battle.find_all_by_query("相手の棋風:王道", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("相手の棋風:変態", target_owner: battle.memberships.black.user).count == 0 }
      end
    end

    describe "棋力" do
      def case1
        Swars::Battle.create!.tap do |e|
          e.memberships.black.update!(grade_key: "1級")
          e.memberships.white.update!(grade_key: "2級")
        end
      end

      it "grade" do
        battle = case1
        assert { Swars::Battle.find_all_by_query("自分の棋力:1級", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("自分の棋力:2級", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "vs-grade" do
        battle = case1
        assert { Swars::Battle.find_all_by_query("相手の棋力:2級", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("相手の棋力:1級", target_owner: battle.memberships.black.user).count == 0 }
      end
    end

    describe "タグ" do
      def case1
        Swars::Battle.create!.tap do |e|
          e.memberships.black.update!(attack_tag_list: "black")
          e.memberships.white.update!(attack_tag_list: "white")
        end
      end

      it "自分に対して" do
        battle = case1
        user = battle.memberships.black.user
        assert { Swars::Battle.find_all_by_query("tag:black", target_owner: user).count       == 1 }
        assert { Swars::Battle.find_all_by_query("or-tag:black", target_owner: user).count    == 1 }
        assert { Swars::Battle.find_all_by_query("-tag:black", target_owner: user).count      == 0 }
      end

      it "相手に対して" do
        battle = case1
        user = battle.memberships.black.user
        assert { Swars::Battle.find_all_by_query("vs-tag:white", target_owner: user).count    == 1 }
        assert { Swars::Battle.find_all_by_query("vs-or-tag:white", target_owner: user).count == 1 }
        assert { Swars::Battle.find_all_by_query("-vs-tag:white", target_owner: user).count   == 0 }
      end
    end

    describe "整数" do
      it "think_max" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(think_max: 5) }
        assert { Swars::Battle.find_all_by_query("think_max:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("think_max:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "think_last" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(think_last: 5) }
        assert { Swars::Battle.find_all_by_query("think_last:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("think_last:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "think_all_avg" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(think_all_avg: 5) }
        assert { Swars::Battle.find_all_by_query("think_all_avg:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("think_all_avg:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "ai_wave_count" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(ai_wave_count: 5) }
        assert { Swars::Battle.find_all_by_query("ai_wave_count:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("ai_wave_count:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "ai_drop_total" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(ai_drop_total: 5) }
        assert { Swars::Battle.find_all_by_query("ai_drop_total:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("ai_drop_total:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end

      it "grade_diff" do
        battle = Swars::Battle.create!.tap { |e| e.memberships.black.update!(grade_diff: 5) }
        assert { Swars::Battle.find_all_by_query("力差:==5", target_owner: battle.memberships.black.user).count == 1 }
        assert { Swars::Battle.find_all_by_query("力差:!=5", target_owner: battle.memberships.black.user).count == 0 }
      end
    end
  end
end
