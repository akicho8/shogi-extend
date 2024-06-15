require "rails_helper"

module Swars
  RSpec.describe User::Stat::FrequencyExtractor, type: :model, swars_spec: true do
    around do |e|
      capture(:stdout) { e.run }
    end

    it "works" do
      Battle.create!
      options = {
        :user_keys      => User.pluck(:key),
        :battle_count_gteq => 0,
      }
      assert { Swars::User::Stat::FrequencyExtractor.new.call(options) }
    end
  end
end
