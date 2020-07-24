require 'rails_helper'

module Actb
  RSpec.describe BestQuestionsGenerator, type: :model do
    include ActbSupportMethods

    before do
      question1
    end

    it do
      Rule.find_each do |rule|
        battle1.room.update!(rule: rule)
        generator = BestQuestionsGenerator.new(battle: battle1)
        # puts generator.db_scope.to_sql
        # tp generator.generate
        assert { generator.generate.size >= 1 }
      end
    end
  end
end
