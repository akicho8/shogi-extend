require "./setup"

QueryInfo.parse("foo:>=").lookup_one(:foo)   # => ">="
QueryInfo.parse("foo:>=-1").lookup_one(:foo) # => {:operator=>:gteq, :value=>-1}
QueryInfo.parse("foo:>=1").lookup_one(:foo)  # => {:operator=>:gteq, :value=>1}
QueryInfo.parse("foo:>").lookup_one(:foo)    # => ">"
QueryInfo.parse("foo:>-1").lookup_one(:foo)  # => {:operator=>:gt, :value=>-1}
QueryInfo.parse("foo:>1").lookup_one(:foo)   # => {:operator=>:gt, :value=>1}
QueryInfo.parse("foo:=").lookup_one(:foo)    # => "="
QueryInfo.parse("foo:==1").lookup_one(:foo)  # => {:operator=>:eq, :value=>1}
QueryInfo.parse("foo:!=1").lookup_one(:foo)  # => {:operator=>:not_eq, :value=>1}

QueryInfo.parse("foo tag:a")    # => #<QueryInfo:0x000000010b9cd680 @options={:available_keys=>nil}, @query="foo tag:a", @attributes={:tag=>["a"]}, @values=["foo"], @urls=[]>
QueryInfo.parse("id:1,2,3").lookup_first([:ids, :id]) # => ["1", "2", "3"]

QueryInfo.parse("").lookup(:foo) # => nil
QueryInfo.parse("foo:>1 foo:>2").lookup(:foo) # => [{:operator=>:gt, :value=>1}, {:operator=>:gt, :value=>2}]
QueryInfo.parse("foo:1 foo:2").lookup(:foo) # => ["1", "2"]

QueryInfo.parse("xxxxxxxxxx").swars_user_key # => <xxxxxxxxxx>
QueryInfo.parse("xxxxxxxxxx").swars_user     # => nil

QueryInfo.parse("BOUYATETSU5").swars_user_key # => <BOUYATETSU5>
QueryInfo.parse("BOUYATETSU5").swars_user     # => #<Swars::User id: 228939, user_key: "BOUYATETSU5", grade_id: 4, last_reception_at: "2024-08-14 14:12:22.000000000 +0900", search_logs_count: 34507, created_at: "2020-05-05 20:42:36.000000000 +0900", updated_at: "2024-08-14 14:12:22.000000000 +0900", ban_at: nil, latest_battled_at: "2024-07-05 23:44:37.000000000 +0900">
