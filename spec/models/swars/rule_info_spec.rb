require 'rails_helper'

module Swars
  RSpec.describe RuleInfo, type: :model do
    it "works" do
      assert { RuleInfo.fetch("3分") }
    end
  end
end
