require "rails_helper"

RSpec.describe QueryInfo do
  it "キーから値を取る" do
    assert2 { QueryInfo.parse("foo:a").lookup("foo") == ["a"] }
  end

  it "カンマで区切ってあれば分割する" do
    assert2 { QueryInfo.parse("foo:a,b").lookup("foo") == ["a", "b"] }
  end

  it "複数あれば一つにまとめる" do
    assert2 { QueryInfo.parse("foo:a foo:b").lookup("foo") == ["a", "b"] }
  end

  it "重複は省く" do
    assert2 { QueryInfo.parse("foo:a foo:a").lookup("foo") == ["a"] }
  end

  it "日本語に対応する" do
    assert2 { QueryInfo.parse("鍵1:値1").lookup("鍵1") ==  ["値1"] }
  end

  it "値が-や!で始まっていても(いまのところは)特別に何かはしない" do
    assert2 { QueryInfo.parse("手合割:-平手").lookup("手合割") ==  ["-平手"] }
    assert2 { QueryInfo.parse("手合割:!平手").lookup("手合割") ==  ["!平手"] }
  end

  it "1つ目だけの値を返す" do
    assert2 { QueryInfo.parse("foo:a,b").lookup_one("foo") == "a" }
  end

  it "URLだけは特別扱いで切り出す" do
    assert2 { QueryInfo.parse("xxx https://localhost/ xxx").urls == ["https://localhost/"] }
  end

  it "比較演算子タイプのときだけ値を返す" do
    assert2 { QueryInfo.parse("foo:==0").lookup_op(:foo)      }
    assert2 { QueryInfo.parse("foo:0").lookup_op(:foo) == nil }
  end

  it "比較演算子" do
    assert2 { QueryInfo.parse("foo:>=").lookup_one(:foo)   == ">="                               }
    assert2 { QueryInfo.parse("foo:>=-1").lookup_one(:foo) == {:operator => :gteq, :value => -1} }
    assert2 { QueryInfo.parse("foo:>=1").lookup_one(:foo)  == {:operator => :gteq, :value => 1 } }
    assert2 { QueryInfo.parse("foo:>").lookup_one(:foo)    == ">"                                }
    assert2 { QueryInfo.parse("foo:>-1").lookup_one(:foo)  == {:operator => :gt,   :value => -1} }
    assert2 { QueryInfo.parse("foo:>1").lookup_one(:foo)   == {:operator => :gt,   :value => 1 } }
    assert2 { QueryInfo.parse("foo:=").lookup_one(:foo)    == "="                                }
    assert2 { QueryInfo.parse("foo:==1").lookup_one(:foo)  == {:operator => :eq,   :value => 1 } }
  end
end
