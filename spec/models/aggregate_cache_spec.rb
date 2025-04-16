require "rails_helper"

RSpec.describe AggregateCache, type: :model, swars_spec: true do
  it "works" do
    assert { AggregateCache.group(:group_name).count == {} }

    AggregateCache["A"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }

    AggregateCache["A"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1 } }

    AggregateCache["B"].write
    AggregateCache["B"].write
    assert { AggregateCache.group(:group_name).count == { "A" => 1, "B" => 1 } }
  end

  it "write" do
    assert { AggregateCache["A"].write(foo: 1) == { foo: 1 } }
    AggregateCache.group(:group_name).count == { "A" => 1 }
  end

  it "read" do
    AggregateCache["A"].write({ "foo" => 1 })
    AggregateCache["A"].read == { :foo => 1 }
  end

  it "読み出し時にはすべてのキーをシンボルにする" do
    AggregateCache["A"].write({ "a" => { "b" => "c" } })
    assert { AggregateCache["A"].read == { :a => { :b => "c" } } }
  end

  it "値がハッシュではない場合にエラーとする" do
    assert { (AggregateCache["A"].write("a") rescue $!).is_a?(TypeError) }
  end

  it "fetch" do
    assert { AggregateCache["A"].fetch { { "x" => 1 } } == { x: 1 } }
    assert { AggregateCache["A"].fetch { { "x" => 2 } } == { x: 1 } }
  end
end
