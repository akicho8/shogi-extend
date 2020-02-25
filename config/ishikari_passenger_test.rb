require "faraday"
require "rspec/autorun"
RSpec.configure do |config|
  config.expect_with :test_unit
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

  def test(url, message)
    e = Faraday.get(url)
    [e.status, e.headers["location"]].compact
  rescue => e
    e
  end
end
