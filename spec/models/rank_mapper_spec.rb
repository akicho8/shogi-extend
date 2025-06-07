require "rails_helper"

RSpec.describe RankMapper, type: :model do
  it "works" do
    assert { RankMapper.new([30, 20, 20, 10]).to_a == [3, 1, 1, 0] }
  end
end
# >> Run options: exclude {chat_gpt_spec: true, login_spec: true, slow_spec: true}
# >> 
# >> RankMapper
# >>   works
# >> 
# >> Top 1 slowest examples (0.13804 seconds, 5.5% of total time):
# >>   RankMapper works
# >>     0.13804 seconds -:4
# >> 
# >> Finished in 2.5 seconds (files took 1.56 seconds to load)
# >> 1 example, 0 failures
# >> 
