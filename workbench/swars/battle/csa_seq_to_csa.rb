require "./setup"

battle = Swars::Battle.create!
battle.final_info               # => #<Swars::FinalInfo:0x000000010bab4530 @attributes={:key=>:TORYO, :name=>"投了", :alias_name=>nil, :label_color=>nil, :csa_last_action_key=>:TORYO, :draw=>false, :toryo_or_tsumi=>true, :chart_required=>true, :code=>0}, @db_class=Swars::Final(id: integer, key: string, position: integer, created_at: datetime, updated_at: datetime)>
puts battle.kifu_body           # => nil
# >> N+user1040531 30級
# >> N-user1040532 30級
# >> $START_TIME:2025/02/26 20:44:38
# >> $EVENT:将棋ウォーズ(10分切れ負け)
# >> $TIME_LIMIT:00:10+00
# >> $X_FINAL:投了
# >> $X_WINNER:▲
# >> +
# >> +7968GI,T0
# >> -8232HI,T0
# >> +5756FU,T0
# >> -3334FU,T0
# >> +6857GI,T0
# >> %TORYO
