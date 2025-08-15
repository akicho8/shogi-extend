require "rails_helper"

RSpec.describe Swars::Battle::CleanerMethods, type: :model, swars_spec: true do
  describe "scope" do
    describe "old_only" do
      it "old_only" do
        Timecop.freeze("2000-01-01 00:00:00") { Swars::Battle.create! }
        Timecop.freeze("2000-01-01 00:00:00") { assert { Swars::Battle.old_only(1).count == 0 } }
        Timecop.freeze("2000-01-01 00:00:01") { assert { Swars::Battle.old_only(1).count == 1 } }
      end
    end

    describe "pro_only / pro_except" do
      def case1(grade_key)
        Swars::Battle.create! do |e|
          e.memberships.build(user: Swars::User.create!(grade_key: grade_key))
        end
      end

      it "pro_only" do
        case1("九段")
        assert { Swars::Battle.pro_only.count == 0 }
        case1("十段")
        assert { Swars::Battle.pro_only.count == 1 }
      end

      it "pro_except" do
        case1("九段")
        assert { Swars::Battle.pro_except.count == 1 }
        case1("十段")
        assert { Swars::Battle.pro_except.count == 1 }
      end
    end

    describe "ban_only / ban_except" do
      def case1(ban_at)
        Swars::Battle.create! do |e|
          e.memberships.build(user: Swars::User.create!(ban_at: ban_at))
        end
      end

      it "ban_only" do
        assert { Swars::Battle.ban_only.count == 0 }
        case1(Time.current)
        assert { Swars::Battle.ban_only.count == 1 }
      end

      it "ban_except" do
        assert { Swars::Battle.ban_except.count == 0 }
        case1(Time.current)
        assert { Swars::Battle.ban_except.count == 0 }
      end
    end

    describe "user_only / user_except" do
      def case1(*user_keys)
        user_keys.each do |user_key|
          Swars::Battle.create! do |e|
            e.memberships.build(user: Swars::User.create!(key: user_key))
          end
        end
      end

      it "user_only" do
        assert { Swars::Battle.user_only(["alice"]).count == 0 }
        case1("alice")
        assert { Swars::Battle.user_only(["alice"]).count == 1 }
      end

      it "user_except" do
        assert { Swars::Battle.user_except(["alice"]).count == 0 }
        case1("alice")
        assert { Swars::Battle.user_except(["alice"]).count == 0 }
        case1("bob")
        assert { Swars::Battle.user_except(["alice"]).count == 1 }
      end
    end

    describe "xmode_only / xmode_except" do
      def case1(*xmode_keys)
        xmode_keys.each do |xmode_key|
          Swars::Battle.create!(xmode_key: xmode_key)
        end
      end

      it "xmode_only" do
        assert { Swars::Battle.xmode_only("友達").count == 0 }
        case1("友達")
        assert { Swars::Battle.xmode_only("友達").count == 1 }
      end

      it "xmode_except" do
        assert { Swars::Battle.xmode_except("友達").count == 0 }
        case1("友達")
        assert { Swars::Battle.xmode_except("友達").count == 0 }
      end
    end

    describe "coaching_only / coaching_except" do
      def case1(*xmode_keys)
        xmode_keys.each do |xmode_key|
          Swars::Battle.create!(xmode_key: xmode_key)
        end
      end

      it "coaching_only" do
        assert { Swars::Battle.coaching_only.count == 0 }
        case1("指導")
        assert { Swars::Battle.coaching_only.count == 1 }
      end

      it "coaching_except" do
        assert { Swars::Battle.coaching_except.count == 0 }
        case1("指導")
        assert { Swars::Battle.coaching_except.count == 0 }
      end
    end
  end

  it "cleaner" do
    Swars::Battle.create!
    Swars::Battle.cleaner(execute: true).call
    assert { Swars::Battle.count == 0 }

    Swars::Battle.create!
    Swars::Battle.none.cleaner(execute: true).call
    assert { Swars::Battle.count == 1 }
  end

  describe "cleaner_n / cleaner_s" do
    def case1
      user_key = Swars::User::Vip.long_time_keep_user_keys.first
      Swars::Battle.create! do |e|
        e.memberships.build(user: Swars::User.create!(user_key: user_key))
      end
    end

    it "cleaner_n: しばらく棋譜を残しておく利用者のため棋譜はまだ残っている" do
      case1
      Swars::Battle.cleaner_n(execute: true).call
      assert { Swars::Battle.count == 1 }
    end

    it "cleaner_s: しばらく棋譜を残しておく利用者だがそれでもいつかは削除する" do
      case1
      Swars::Battle.cleaner_s(execute: true).call
      assert { Swars::Battle.count == 0 }
    end
  end
end
