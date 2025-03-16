require "rails_helper"

RSpec.describe Swars::User::Stat::FrequencyExtractor, type: :model, swars_spec: true do
  around do |e|
    capture(:stdout) { e.run }
  end

  it "works" do
    Swars::Battle.create!
    options = {
      :user_keys      => Swars::User.pluck(:key),
      :battle_count_gteq => 0,
    }
    assert { Swars::User::Stat::FrequencyExtractor.new.call(options) }
  end
end
