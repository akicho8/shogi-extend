require 'rails_helper'

module Actb
  RSpec.describe BestQuestionsGenerator, type: :model do
    include ActbSupportMethods

    it do
      assert { BestQuestionsGenerator.new(battle: battle1).generate }
    end
  end
end
