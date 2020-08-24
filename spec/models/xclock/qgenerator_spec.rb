require 'rails_helper'

module Xclock
  RSpec.describe Qgenerator, type: :model do
    include XclockSupportMethods

    before do
      question1
    end

    it "works" do
      RuleInfo.each do |rule_info|
        assert { Qgenerator.new(rule_info: rule_info, users: [user1, user2]).generate }
      end
    end

    it "出題調整" do
      Xclock::Question.destroy_all
      a_questions = 2.times.collect { user1.xclock_questions.create_mock1 } # A
      b_questions = 2.times.collect { user1.xclock_questions.create_mock1 } # B

      # B だけ履歴作成
      b_questions.each do |e|
        user1.xclock_histories.create!(question: e, ox_mark: OxMark.fetch("correct"))
        user1.xclock_histories.create!(question: e, ox_mark: OxMark.fetch("correct"))
      end

      users = [user1, user2]
      Qgenerator.new.history_latest_questions.to_sql # => "SELECT `xclock_histories`.* FROM `xclock_histories` WHERE `xclock_histories`.`ox_mark_id` = 1 GROUP BY `xclock_histories`.`question_id` ORDER BY MAX(created_at) DESC LIMIT 100"
      Qgenerator.new.history_latest_questions.pluck(:question_id)    # => [826, 827]

      # B は含まれていない
      ids1 = Qgenerator.new(rule_info: RuleInfo[:test_rule], users: users, fill: false).generate.collect(&:id).sort
      ids1                             # => [824, 825]
      ids2 = a_questions.collect(&:id) # => [824, 825]
      assert { ids1 == ids2 }

      # fill: true なら補完している
      ids1 = Qgenerator.new(rule_info: RuleInfo[:test_rule], users: users, fill: true).generate.collect(&:id).sort
      ids1                                                  # => [824, 825, 826, 827]
      ids2 = (a_questions + b_questions).collect(&:id).sort # => [824, 825, 826, 827]
      assert { ids1 == ids2 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.95 seconds (files took 2.13 seconds to load)
# >> 2 examples, 0 failures
# >> 
