require "./setup"

battle = Swars::Battle.create!
battle.final_info               # => #<Swars::FinalInfo:0x0000000106e3c7c0 @attributes={:key=>:TORYO, :name=>"投了", :alias_name=>nil, :label_color=>nil, :csa_last_action_key=>:TORYO, :draw=>false, :toryo_or_tsumi=>true, :chart_required=>true, :code=>0}, @db_class=Swars::Final(id: integer, key: string, position: integer, created_at: datetime, updated_at: datetime)>
puts battle.kifu_body           # => nil
# >> N+user967171 30級
# >> N-user967172 30級
# >> $START_TIME:2024/09/07 17:21:30
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
