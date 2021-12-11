require "rails_helper"

RSpec.describe QueryInfo do
  it "キーから値を取る" do
    assert { QueryInfo.parse("foo:a").lookup("foo") == ["a"] }
  end

  it "カンマで区切ってあれば分割する" do
    assert { QueryInfo.parse("foo:a,b").lookup("foo") == ["a", "b"] }
  end

  it "複数あれば一つにまとめる" do
    assert { QueryInfo.parse("foo:a foo:b").lookup("foo") == ["a", "b"] }
  end

  it "重複は省く" do
    assert { QueryInfo.parse("foo:a foo:a").lookup("foo") == ["a"] }
  end

  it "日本語に対応する" do
    assert { QueryInfo.parse("鍵1:値1").lookup("鍵1") ==  ["値1"] }
  end

  it "1つ目だけの値を返す" do
    assert { QueryInfo.parse("foo:a,b").lookup_one("foo") == "a" }
  end

  it "URLだけは特別扱いで切り出す" do
    assert { QueryInfo.parse("xxx https://localhost/ xxx").urls == ["https://localhost/"] }
  end

  it "比較演算子タイプのときだけ値を返す" do
    assert { QueryInfo.parse("foo:==0").lookup_op(:foo)      }
    assert { QueryInfo.parse("foo:0").lookup_op(:foo) == nil }
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
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> .........
# >> 
# >> Top 9 slowest examples (0.10919 seconds, 5.7% of total time):
# >>   QueryInfo キーから値を取れる
# >>     0.09349 seconds -:4
# >>   QueryInfo 比較演算子
# >>     0.00526 seconds -:37
# >>   QueryInfo 重複は省く
# >>     0.00252 seconds -:16
# >>   QueryInfo 複数あれば一つにまとめる
# >>     0.00197 seconds -:12
# >>   QueryInfo 比較演算子タイプのときだけ値を返す
# >>     0.00159 seconds -:32
# >>   QueryInfo カンマで区切ってあれば分割する
# >>     0.00117 seconds -:8
# >>   QueryInfo 日本語に対応する
# >>     0.00112 seconds -:20
# >>   QueryInfo 1つ目だけの値を返す
# >>     0.00105 seconds -:24
# >>   QueryInfo URLだけは特別扱いで切り出す
# >>     0.00101 seconds -:28
# >> 
# >> Finished in 1.9 seconds (files took 3.59 seconds to load)
# >> 9 examples, 0 failures
# >> 
