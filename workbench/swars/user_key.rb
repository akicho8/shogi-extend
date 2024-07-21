require "./setup"
user_key = Swars::UserKey["alice"]
user_key.official_mypage_url    # => "https://shogiwars.heroz.jp/users/mypage/alice"
user_key.official_follow_url    # => "https://shogiwars.heroz.jp/friends?type=follow&user_id=alice"
user_key.official_follower_url  # => "https://shogiwars.heroz.jp/friends?type=follower&user_id=alice"
user_key.swars_search_url       # => "http://localhost:4000/swars/search?query=alice"
user_key.player_info_url        # => "http://localhost:4000/swars/users/alice"
user_key.google_search_url      # => "https://www.google.co.jp/search?q=alice+%E5%B0%86%E6%A3%8B"
user_key.twitter_search_url     # => "https://twitter.com/search?q=alice+%E5%B0%86%E6%A3%8B"
