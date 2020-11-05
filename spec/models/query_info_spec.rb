require 'rails_helper'

RSpec.describe QueryInfo do
  let :query_info do
    QueryInfo.parse("foo:a foo:a foo:b,c https://localhost/")
  end

  it "lookup" do
    assert { query_info.lookup("foo") == ["a", "b", "c"] }
  end

  it "lookup_one" do
    assert { query_info.lookup_one("foo") == "a" }
  end

  it "urls" do
    assert { query_info.urls == ["https://localhost/"] }
  end

  it "比較演算子" do
    assert { QueryInfo.parse("foo:>=").lookup_one(:foo)   == ">="                               }
    assert { QueryInfo.parse("foo:>=-1").lookup_one(:foo) == {:operator => :gteq, :value => -1} }
    assert { QueryInfo.parse("foo:>=1").lookup_one(:foo)  == {:operator => :gteq, :value => 1 } }
    assert { QueryInfo.parse("foo:>").lookup_one(:foo)    == ">"                                }
    assert { QueryInfo.parse("foo:>-1").lookup_one(:foo)  == {:operator => :gt,   :value => -1} }
    assert { QueryInfo.parse("foo:>1").lookup_one(:foo)   == {:operator => :gt,   :value => 1 } }
    assert { QueryInfo.parse("foo:=").lookup_one(:foo)    == "="                                }
    assert { QueryInfo.parse("foo:==1").lookup_one(:foo)  == {:operator => :eq,   :value => 1 } }
  end
end
