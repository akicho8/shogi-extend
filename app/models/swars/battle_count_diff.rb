module Swars
  class BattleCountDiff
    def call(user_key)
      user = User.find_by(key: user_key)
      before_count = 0
      after_count = 0
      if user
        before_count = user.battles.count
      end
      yield
      if user
        after_count = user.battles.count
      end
      {
        :before_count => before_count,
        :after_count  => after_count,
        :diff_count   => after_count - before_count,
      }
    end
  end
end
