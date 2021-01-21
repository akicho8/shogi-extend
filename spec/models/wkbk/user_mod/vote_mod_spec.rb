require 'rails_helper'

module Wkbk
  RSpec.describe UserMod::VoteMod, type: :model do
    include WkbkSupportMethods

    describe "評価" do
      def test1(vote_key)
        user1.vote_handle(question_id: question1.id, vote_key: vote_key)
        question1.reload
        [question1.good_marks_count, question1.bad_marks_count]
      end

      it "片方を押すと片方は解除する" do
        assert { test1(:good) == [1, 0] }
        assert { test1(:good) == [0, 0] }
        assert { test1(:good) == [1, 0] }
        assert { test1(:bad)  == [0, 1] }
        assert { test1(:bad)  == [0, 0] }
        assert { test1(:bad)  == [0, 1] }
        assert { test1(:good) == [1, 0] }
      end

      it "json" do
        retv = user1.vote_handle(question_id: question1.id, vote_key: :good)
        assert { retv == {question_id: question1.id, good: {enabled: true, diff: 1, count: 1}, bad: {enabled: false, diff: 0, count: 0}} }
      end
    end

    describe "高評価率" do
      def test1(vote_key)
        user1.vote_handle(question_id: question1.id, vote_key: vote_key)
        question1.reload
        question1.good_rate.to_f
      end

      it "高評価率" do
        assert { test1(:good) == 1.0 }
        assert { test1(:bad)  == 0.0 }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ...
# >> 
# >> Finished in 1.01 seconds (files took 2.16 seconds to load)
# >> 3 examples, 0 failures
# >> 
