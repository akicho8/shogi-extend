require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    def test1(users)
      users = users.collect do |user_key, grade_key|
        User.create!(user_key: user_key, grade: Grade.fetch(grade_key))
      end
      Battle.create_with_members!(users)
    end

    def cleanup(options = {})
      options = {
        time_limit: nil,
        expires_in: 0,
      }.merge(options)

      Battle.cleanup_scope(options)
    end

    it "普通の棋譜は削除される" do
      test1("user1" => "1級", "user2" => "2級")
      assert { cleanup.count == 1 }
    end

    it "十段の棋譜は削除しない" do
      test1("user1" => "十段", "user2" => "2級")
      assert { cleanup.count == 0 }
    end

    it "古くなったものだけ削除する" do
      Timecop.freeze("2000-01-01") do
        test1("user1" => "1級", "user2" => "2級")
      end
      Timecop.freeze("2000-01-01 00:00:00") { assert { cleanup(expires_in: 1).count == 0 } }
      Timecop.freeze("2000-01-01 00:00:01") { assert { cleanup(expires_in: 1).count == 1 } }
    end

    it "指定ユーザーのバトルは削除しない" do
      test1("user1" => "1級", "user2" => "2級")
      assert { cleanup(skip_users: ["user1"]).count == 0 }
    end

    it "削除実行" do
      test1("user1" => "1級", "user2" => "2級")
      Battle.cleanup(time_limit: nil, expires_in: 0)
      assert { Battle.count == 0 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .....
# >> 
# >> Finished in 2.34 seconds (files took 3.29 seconds to load)
# >> 5 examples, 0 failures
# >> 
