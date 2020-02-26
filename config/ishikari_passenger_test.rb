require "faraday"
require "rspec/autorun"
RSpec.configure do |config|
  config.expect_with :test_unit
end

def test(url, message)
  e = Faraday.get(url)
  [e.status, e.headers["location"]].compact
rescue => e
  e
end

RSpec.describe do
  it do
    assert { test("http://www.shogi-extend.com", "http -> https")     == [301, "https://www.shogi-extend.com/"]     }
    assert { test("https://www.shogi-extend.com", "https 見れる")     == [200]                                      }

    assert { test("http://staging.shogi-extend.com", "http -> https") == [301, "https://staging.shogi-extend.com/"] }
    assert { test("https://staging.shogi-extend.com", "https 見れる") == [200]                                      }

    assert { test("https://shogi-extend.com", "www をつける")         == [301, "https://www.shogi-extend.com/"]     }
    assert { test("http://shogi-extend.com", "まず https に飛ぶ")     == [301, "https://shogi-extend.com/"]         }
  end

  it "旧サイトからのリダイレクト" do
    # assert { test("https://staging.shogi-extend.com", "新サイトへ")      == [301, "https://www.shogi-extend.com/"]   }
    # assert { test("http://tk2-221-20341.vs.sakura.ne.jp", "新サイトへ") == [301, "https://www.shogi-extend.com/"]   }
    # assert { test("https://staging.shogi-extend.com/shogi/w?query=kinakom0chi", "新サイトへ") == [301, "https://www.shogi-extend.com/w?query=kinakom0chi"] }
    assert { test("http://tk2-221-20341.vs.sakura.ne.jp/shogi/w?query=kinakom0chi", "新サイトへ") == [301, "https://www.shogi-extend.com/w?query=kinakom0chi"]   }
  end
end
# >> ..
# >> 
# >> Finished in 1.05 seconds (files took 0.17027 seconds to load)
# >> 2 examples, 0 failures
# >> 
