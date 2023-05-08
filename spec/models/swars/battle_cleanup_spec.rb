require "rails_helper"

module Swars
  RSpec.describe "対象の削除を実行", type: :model, swars_spec: true do
    def case1(users, attributes = {})
      users = users.collect do |user_key, grade_key|
        User.create!(user_key: user_key, grade: Grade.fetch(grade_key))
      end
      Battle.create_with_members!(users, attributes)
    end

    it "すべてが対象になっているので全削除する" do
      case1("user1" => "1級", "user2" => "2級")
      Battle.cleanup(execute: true)
      assert2 { Battle.count == 0 }
    end

    it "user1 は対象外なので削除しない" do
      case1("user1" => "1級", "user2" => "2級")
      Battle.cleanup(execute: true, skip_users: ["user1"])
      assert2 { Battle.count == 1 }
    end
  end
end
