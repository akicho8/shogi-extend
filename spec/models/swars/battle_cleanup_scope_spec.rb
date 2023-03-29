require "rails_helper"

module Swars
  RSpec.describe "削除対象を絞り込む", type: :model, swars_spec: true do
    def case1(users, attributes = {})
      users = users.collect do |user_key, grade_key|
        User.create!(user_key: user_key, grade: Grade.fetch(grade_key))
      end
      Battle.create_with_members!(users, attributes)
    end

    def cleanup_scope(options = {})
      options = {
        :time_limit => nil,
        :expires_in => 0,
      }.merge(options)

      Battle.cleanup_scope(options)
    end

    it "普通の棋譜は削除される" do
      case1("user1" => "1級", "user2" => "2級")
      assert2 { cleanup_scope.count == 1 }
    end

    it "十段の棋譜は削除しない" do
      case1("user1" => "十段", "user2" => "2級")
      assert2 { cleanup_scope.count == 0 }
    end

    it "指導対局は削除しない" do
      case1({"user1" => "1級", "user2" => "2級"}, xmode: Xmode.fetch("指導"))
      assert2 { cleanup_scope.count == 0 }
    end

    it "古くなったものだけ削除する" do
      Timecop.freeze("2000-01-01") do
        case1("user1" => "1級", "user2" => "2級")
      end
      Timecop.freeze("2000-01-01 00:00:00") { assert2 { cleanup_scope(expires_in: 1).count == 0 } }
      Timecop.freeze("2000-01-01 00:00:01") { assert2 { cleanup_scope(expires_in: 1).count == 1 } }
    end

    it "指定ユーザーのバトルは削除しない" do
      case1("user1" => "1級", "user2" => "2級")
      assert2 { cleanup_scope(skip_users: ["user1"]).count == 0 }
    end
  end
end
