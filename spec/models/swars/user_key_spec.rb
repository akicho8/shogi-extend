require "rails_helper"

RSpec.describe Swars::UserKey, type: :model, swars_spec: true do
  it "works" do
    user_key = Swars::UserKey["alice"]
    assert { user_key.official_mypage_url   == "https://shogiwars.heroz.jp/users/mypage/alice"                  }
    assert { user_key.official_follow_url   == "https://shogiwars.heroz.jp/friends?type=follow&user_id=alice"   }
    assert { user_key.official_follower_url == "https://shogiwars.heroz.jp/friends?type=follower&user_id=alice" }
    assert { user_key.swars_search_url      == "http://localhost:4000/swars/search?query=alice"                 }
    assert { user_key.player_info_url       == "http://localhost:4000/swars/users/alice"                        }
    assert { user_key.google_search_url     == "https://www.google.co.jp/search?q=alice+%E5%B0%86%E6%A3%8B"     }
    assert { user_key.twitter_search_url    == "https://twitter.com/search?q=alice+%E5%B0%86%E6%A3%8B"          }
    assert { !user_key.blocked? }
  end
end
