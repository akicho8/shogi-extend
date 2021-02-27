require 'rails_helper'

module Swars
  RSpec.describe Battle, type: :model do
    before do
      Swars.setup
    end

    def test1(a, b, c, d)
      user1 = User.create!(user_key: a, grade: Grade.fetch(b))
      user2 = User.create!(user_key: c, grade: Grade.fetch(d))
      Battle.create_with_members!([user1, user2])
    end

    def kill_run(options = {})
      options = {
        time_limit: nil,
        expires_in: 0,
      }.merge(options)
      Battle.kill_scope(options)
    end

    it "普通の棋譜は削除される" do
      test1("user1", "1級", "user2", "2級")
      assert { kill_run.count == 1 }
    end

    it "十段の棋譜は削除しない" do
      test1("user1", "十段", "user2", "2級")
      assert { kill_run.count == 0 }
    end

    it "古くなったものだけ削除する" do
      Timecop.freeze("2000-01-01") do
        test1("user1", "1級", "user2", "2級")
      end
      Timecop.freeze("2000-01-01 00:00:00") { assert { kill_run(expires_in: 1).count == 0 } }
      Timecop.freeze("2000-01-01 00:00:01") { assert { kill_run(expires_in: 1).count == 1 } }
    end

    it "指定ユーザーのバトルは削除しない" do
      test1("user1", "1級", "user2", "2級")
      assert { kill_run(skip_users: ["user1"]).count == 0 }
    end

    it "削除実行" do
      test1("user1", "1級", "user2", "2級")
      Battle.cleanup(time_limit: nil, expires_in: 0)
      assert { Battle.count == 0 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ....
# >>
# >> Finished in 1.66 seconds (files took 2.49 seconds to load)
# >> 4 examples, 0 failures
# >>
