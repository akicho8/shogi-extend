require "./setup"
QueryInfo.swars_user_key_extract("") # => nil
QueryInfo.swars_user_key_extract("alice") # => "alice"
QueryInfo.swars_user_key_extract("alice bob") # => "alice"
QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/games/alice-bob-20200204_211329") # => "alice"
QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/users/alice") # => "alice"
QueryInfo.swars_user_key_extract("https://shogiwars.heroz.jp/users/history/alice?gtype=&locale=ja") # => "alice"
QueryInfo.swars_user_key_extract("将棋ウォーズ棋譜(alice:5級 vs bob:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/alice-bob-20200927_180900?tw=1") # => "alice"
