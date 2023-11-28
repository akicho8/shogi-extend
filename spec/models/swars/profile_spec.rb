require "rails_helper"

module Swars
  RSpec.describe Profile, type: :model, swars_spec: true do
    it "ユーザーを作るとprofileモデルも同時に作りリレーションが正しい" do
      user = User.create!
      assert { user.profile }
      assert { user.profile.user == user }
      assert { user.profile.ban_crawled_count == 0 }
      assert { user.profile.ban_at == nil }
      assert { user.profile.ban_crawled_at }
    end

    describe "垢BAN" do
      # 複雑なのでやめ
      # it "ban_crawled_at を更新すると ban_crawled_count をインクリメントする" do
      #   user = User.create!
      #   user.profile.ban_crawled_at = Time.current
      #   user.save!
      #   assert { user.profile.ban_crawled_count == 1 }
      # end

      it "ban_crawled_count_lteq: 垢BANチェック指定回数以下" do
        user = User.create!
        Profile.ban_crawled_count_lteq(0) == [user.profile]
      end

      it "ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去" do
        user = User.create!
        assert { Profile.ban_crawled_at_lt(user.profile.ban_crawled_at).count == 0     } # ban_crawled_at < ban_crawled_at     なので 0
        assert { Profile.ban_crawled_at_lt(user.profile.ban_crawled_at + 1).count == 1 } # ban_crawled_at < ban_crawled_at + 1 なので 1
      end
    end
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >>
# >> Swars::Profile
# >>   ユーザーを作るとprofileモデルも同時に作りリレーションが正しい (FAILED - 1)
# >>   垢BAN
# >>     ban_crawled_at を更新すると ban_crawled_count をインクリメントする
# >>     ban_crawled_count_lteq: 垢BANチェック指定回数以下
# >>     ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去 (FAILED - 2)
# >>
# >> Failures:
# >>
# >>   1) Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:46:in `block (2 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >>   2) Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>      Failure/Error: Unable to find - to read failed line
# >>      # -:66:in `block (3 levels) in <module:Swars>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:26:in `block (2 levels) in <main>'
# >>
# >> Top 4 slowest examples (0.45333 seconds, 18.0% of total time):
# >>   Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >>     0.1756 seconds -:40
# >>   Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>     0.1344 seconds -:64
# >>   Swars::Profile 垢BAN ban_crawled_at を更新すると ban_crawled_count をインクリメントする
# >>     0.08252 seconds -:52
# >>   Swars::Profile 垢BAN ban_crawled_count_lteq: 垢BANチェック指定回数以下
# >>     0.06082 seconds -:59
# >>
# >> Finished in 2.52 seconds (files took 1.64 seconds to load)
# >> 4 examples, 2 failures
# >>
# >> Failed examples:
# >>
# >> rspec -:40 # Swars::Profile ユーザーを作るとprofileモデルも同時に作りリレーションが正しい
# >> rspec -:64 # Swars::Profile 垢BAN ban_crawled_at_lt: 垢BANチェックの前回が指定日時より過去
# >>
