require "faraday"
require "rspec/autorun"
RSpec.configure do |config|
  config.expect_with :test_unit
end

def test(url, message = nil)
  e = Faraday.get(url)
  [e.status, e.headers["location"]].compact
rescue => e
  e
end

# stagingで実験用
test("https://staging.shogi-extend.com", "新サイトへ")                           # => [200]
test("https://staging.shogi-extend.com/shogi/w?query=kinakom0chi", "新サイトへ") # => [404]

RSpec.describe do
  it "production" do
    assert { test("http://www.shogi-extend.com", "http -> https")     == [301, "https://www.shogi-extend.com/"]     }
    assert { test("https://www.shogi-extend.com", "https 見れる")     == [200]                                      }
  end

  it "staging" do
    assert { test("http://staging.shogi-extend.com", "http -> https") == [301, "https://staging.shogi-extend.com/"] }
    assert { test("https://staging.shogi-extend.com", "https 見れる") == [200]                                      }
  end

  it "www をつける" do
    assert { test("https://shogi-extend.com", "www をつける")         == [301, "https://www.shogi-extend.com/"]     }
    assert { test("http://shogi-extend.com", "まず https に飛ぶ")     == [301, "https://shogi-extend.com/"]         }
  end

  it "旧サイトを丸ごと移動させてはいけない" do
    assert { test("http://tk2-221-20341.vs.sakura.ne.jp") == [403]   }
  end

  it "旧サイトからのリダイレクト" do
    assert { test("http://tk2-221-20341.vs.sakura.ne.jp/shogi/w?query=kinakom0chi", "新サイトへ") == [301, "https://www.shogi-extend.com/w?query=kinakom0chi"] }
    assert { test("http://tk2-221-20341.vs.sakura.ne.jp/shogi/", "新サイトへ")                    == [301, "https://www.shogi-extend.com/"]                    }
    assert { test("http://tk2-221-20341.vs.sakura.ne.jp/shogi", "新サイトへ")                     == [301, "https://www.shogi-extend.com/"]                    }
  end
end
# >> .....
# >> 
# >> Finished in 1.25 seconds (files took 0.59306 seconds to load)
# >> 5 examples, 0 failures
# >> 
