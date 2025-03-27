require "rails_helper"

RSpec.describe AggregateCache, type: :model, swars_spec: true do
  it "works" do
    assert { AggregateCache.group(:group_name).count == {} }

    AggregateCache["A"].write({})
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }

    AggregateCache["A"].write({})
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }

    AggregateCache["B"].write({})
    AggregateCache["B"].write({})
    assert { AggregateCache.group(:group_name).count == { "A" => 1, "B" => 1 } }
  end

  it "write" do
    assert { AggregateCache["A"].write(foo: 1) == {foo: 1} }
    AggregateCache.group(:group_name).count == { "A" => 1 }
  end

  it "read" do
    AggregateCache["A"].write({"foo" => 1})
    AggregateCache["A"].read == {:foo => 1}
  end

  it "読み出し時にはすべてのキーをシンボルにする" do
    AggregateCache["A"].write({"a" => {"b" => "c"}})
    assert { AggregateCache["A"].read == {:a => {:b => "c"}} }
  end

  it "fetch" do
    assert { AggregateCache["A"].fetch { {"x" => 1} } == {x: 1} }
    assert { AggregateCache["A"].fetch { {"x" => 2} } == {x: 1} }
  end
end
# >> Run options: exclude {chat_gpt_spec: true, login_spec: true, slow_spec: true}
# >> 
# >> AggregateCache
# >> 1999-12-31T15:00:00.000Z pid=62604 tid=1e0k INFO: Sidekiq 7.3.9 connecting to Redis with options {size: 10, pool_name: "internal", url: "redis://localhost:6379/4"}
# >>   works
# >>   write
# >>   read
# >>   読み出し時にはすべてのキーをシンボルにする
# >>   fetch
# >> 
# >> Top 5 slowest examples (0.55549 seconds, 20.3% of total time):
# >>   AggregateCache works
# >>     0.24694 seconds -:4
# >>   AggregateCache fetch
# >>     0.10095 seconds -:33
# >>   AggregateCache 読み出し時にはすべてのキーをシンボルにする
# >>     0.08131 seconds -:28
# >>   AggregateCache write
# >>     0.07665 seconds -:18
# >>   AggregateCache read
# >>     0.04964 seconds -:23
# >> 
# >> Finished in 2.73 seconds (files took 1.59 seconds to load)
# >> 5 examples, 0 failures
# >> 
