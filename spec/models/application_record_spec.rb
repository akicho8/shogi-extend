require "rails_helper"

RSpec.describe ApplicationRecord, type: :model do
  it "hankaku_format" do
    assert { ApplicationRecord.hankaku_format("０-９Ａ-Ｚａ-ｚ") == "0-9A-Za-z" }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .
# >> 
# >> Finished in 0.14344 seconds (files took 2.08 seconds to load)
# >> 1 example, 0 failures
# >> 
