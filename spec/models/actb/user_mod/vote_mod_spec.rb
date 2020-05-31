require 'rails_helper'

module Actb
  RSpec.describe UserMod::VoteMod, type: :model do
    include ActbSupportMethods

    describe "評価" do
      def test(vote_key)
        user1.vote_handle(question_id: question1.id, vote_key: vote_key)
        question1.reload
        [question1.good_marks_count, question1.bad_marks_count]
      end

      it "片方を押すと片方は解除する" do
        assert { test(:good) == [1, 0] }
        assert { test(:good) == [0, 0] }
        assert { test(:good) == [1, 0] }
        assert { test(:bad)  == [0, 1] }
        assert { test(:bad)  == [0, 0] }
        assert { test(:bad)  == [0, 1] }
        assert { test(:good) == [1, 0] }
      end

      it "json" do
        retv = user1.vote_handle(question_id: question1.id, vote_key: :good)
        # tp retv
        assert { retv == {good: {enabled: true, diff: 1, count: 1}, bad: {enabled: false, diff: 0, count: 0}} }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.88907 seconds (files took 2.19 seconds to load)
# >> 2 examples, 0 failures
# >> 
