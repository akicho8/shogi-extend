require "./setup"
QueryInfo.swars_user_key("") # => nil
QueryInfo.swars_user_key("alice") # => <alice>
QueryInfo.swars_user_key("alice bob") # => <alice>
QueryInfo.swars_user_key("https://shogiwars.heroz.jp/games/alice-bob-20200204_211329") # => <alice>
QueryInfo.swars_user_key("https://shogiwars.heroz.jp/users/alice") # => <alice>
QueryInfo.swars_user_key("https://shogiwars.heroz.jp/users/history/alice?gtype=&locale=ja") # => <alice>
QueryInfo.swars_user_key("将棋ウォーズ棋譜(alice:5級 vs bob:2級) #shogiwars #棋神解析 https://shogiwars.heroz.jp/games/alice-bob-20200927_180900?tw=1") # => <alice>
