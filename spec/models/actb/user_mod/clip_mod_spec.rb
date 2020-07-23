require 'rails_helper'

module Actb
  RSpec.describe UserMod::ClipMod, type: :model do
    include ActbSupportMethods

    describe "保存リストに追加・解除" do
      def test1
        user1.clip_handle(question_id: question1.id)
        question1.reload
        question1.clip_marks_count
      end

      it do
        assert { test1 == 1 }
        assert { test1 == 0 }
      end

      it "json" do
        retv = user1.clip_handle(question_id: question1.id)
        assert { retv == {question_id: question1.id, clip: {enabled: true, diff: 1, count: 1}} }
      end
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 0.76847 seconds (files took 2.18 seconds to load)
# >> 2 examples, 0 failures
# >> 
